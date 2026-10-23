import importlib.util
import json
import os
from pathlib import Path
import subprocess
import shutil
import tempfile
import unittest

REPO = Path(__file__).resolve().parents[1]

class SetupTests(unittest.TestCase):
    def test_skills_restore_backup_rerun_and_tamper_detection(self):
        with tempfile.TemporaryDirectory(prefix="ideconfig-test-") as tmp:
            home = Path(tmp)
            bindir = home / "bin"
            bindir.mkdir()
            for name in ["codex", "agy", "opencode"]:
                p = bindir / name
                p.write_text("#!/bin/sh\nexit 0\n")
                p.chmod(0o755)
            env = dict(os.environ, HOME=tmp, PATH=str(bindir) + ":/usr/bin:/bin")
            env.pop("CODEX_HOME", None)
            name = json.loads((REPO / "ai/skills-manifest.json").read_text())["skills"][0]["name"]
            existing = home / ".agents/skills" / name
            existing.mkdir(parents=True)
            (existing / "SKILL.md").write_text("keep my previous skill")
            def run(*args):
                return subprocess.run(["python3", str(REPO / "scripts/skills.py"), *args], env=env, text=True, capture_output=True)
            self.assertEqual(run("--dry-run").returncode, 0)
            self.assertFalse((home / ".gemini").exists())
            self.assertEqual(run().returncode, 0)
            backup = list((existing.parent.parent / "skill-backups").glob(name + ".backup.*"))
            self.assertEqual(len(backup), 1)
            self.assertEqual((backup[0] / "SKILL.md").read_text(), "keep my previous skill")
            self.assertEqual(run().returncode, 0)
            self.assertEqual(len(list((existing.parent.parent / "skill-backups").glob(name + ".backup.*"))), 1)
            self.assertEqual(run("--check").returncode, 0)
            self.assertTrue((home / ".codex/skills/playwright/scripts/playwright_cli.sh").is_file())
            target = home / ".gemini/antigravity-cli/skills" / name
            target.unlink()
            target.mkdir()
            (target / "SKILL.md").write_text("changed")
            self.assertNotEqual(run("--check").returncode, 0)

    def test_absent_clients_are_skipped(self):
        with tempfile.TemporaryDirectory(prefix="ideconfig-test-") as tmp:
            env = dict(os.environ, HOME=tmp, PATH="/usr/bin:/bin")
            env.pop("CODEX_HOME", None)
            r = subprocess.run(["python3", str(REPO / "scripts/skills.py")], env=env, capture_output=True, text=True)
            self.assertEqual(r.returncode, 0, r.stderr)
            self.assertIn("0 installed clients", r.stdout)
            self.assertFalse((Path(tmp) / ".agents").exists())
            self.assertFalse((Path(tmp) / ".gemini").exists())

    def test_shell_links_preserve_directories_and_are_idempotent(self):
        with tempfile.TemporaryDirectory(prefix="ideconfig-test-") as tmp:
            work = Path(tmp)
            (work / "source").mkdir()
            (work / "target").mkdir()
            (work / "target/old").write_text("preserved")
            script = 'source "$1"; link_file "$2/source" "$2/target"; link_file "$2/source" "$2/target"'
            r = subprocess.run(["bash", "-c", script, "test", str(REPO / "scripts/common.sh"), tmp], text=True, capture_output=True)
            self.assertEqual(r.returncode, 0, r.stderr)
            self.assertTrue((work / "target").is_symlink())
            saved = list(work.glob("target.backup.*"))
            self.assertEqual(len(saved), 1)
            self.assertEqual((saved[0] / "old").read_text(), "preserved")
            self.assertFalse((work / "source/target").exists())

    @unittest.skipUnless(shutil.which("dbus-run-session") and shutil.which("gsettings"), "GNOME test tools unavailable")
    def test_desktop_apply_check_and_rerun_in_private_session(self):
        schemas = subprocess.check_output(["gsettings", "list-schemas"], text=True)
        if "org.gnome.shell.keybindings" not in schemas:
            self.skipTest("GNOME Shell schemas unavailable")
        with tempfile.TemporaryDirectory(prefix="ideconfig-desktop-test-") as tmp:
            home = Path(tmp)
            applications = home / ".local/share/applications"
            applications.mkdir(parents=True)
            (applications / "google-chrome.desktop").write_text(
                "[Desktop Entry]\nType=Application\nName=Chrome test\nExec=/bin/true %U\n"
                "MimeType=text/html;x-scheme-handler/http;x-scheme-handler/https;\n")
            env = dict(os.environ, HOME=tmp, XDG_CONFIG_HOME=tmp + "/.config",
                       XDG_DATA_HOME=tmp + "/.local/share", XDG_STATE_HOME=tmp + "/.local/state",
                       XDG_CURRENT_DESKTOP="ubuntu:GNOME", GSETTINGS_BACKEND="dconf", BROWSER="previous-browser")
            for key in ["DBUS_SESSION_BUS_ADDRESS", "XDG_RUNTIME_DIR"]:
                env.pop(key, None)
            script = ('python3 scripts/desktop.py && python3 scripts/desktop.py --check && '
                      'python3 scripts/desktop.py && python3 scripts/desktop.py --check')
            result = subprocess.run(["dbus-run-session", "--", "bash", "-c", script],
                                    cwd=REPO, env=env, text=True, capture_output=True, timeout=60)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertEqual(len(list((home / ".local/state/IDEconfig").glob("desktop-before-*"))), 1)

    def test_codex_profile_naming_compatibility(self):
        with tempfile.TemporaryDirectory(prefix="ideconfig-test-") as tmp:
            home = Path(tmp)
            bindir = home / "bin"
            bindir.mkdir()
            p = bindir / "codex"
            p.write_text("#!/bin/sh\nexit 0\n")
            p.chmod(0o755)
            (home / ".codex-a").mkdir()
            (home / ".codex-account-b").mkdir()
            env = dict(os.environ, HOME=tmp, PATH=str(bindir) + ":/usr/bin:/bin")
            env.pop("CODEX_HOME", None)
            r = subprocess.run(["python3", str(REPO / "scripts/skills.py")], env=env, text=True, capture_output=True)
            self.assertEqual(r.returncode, 0, r.stderr)
            self.assertTrue((home / ".codex-a/skills/playwright/scripts/playwright_cli.sh").is_file())
            self.assertTrue((home / ".codex-account-b/skills/playwright/scripts/playwright_cli.sh").is_file())
            check_res = subprocess.run(["python3", str(REPO / "scripts/skills.py"), "--check"], env=env, text=True, capture_output=True)
            self.assertEqual(check_res.returncode, 0, check_res.stderr)

    def test_workspace_profile_has_reachable_exact_destinations(self):
        settings = json.loads((REPO / "desktop/gnome.json").read_text())["settings"]
        lookup = {(s["schema"], s["key"]): s["value"] for s in settings}
        wm = "org.gnome.desktop.wm.keybindings"
        for index, key in enumerate(["grave", "1", "2", "3"], 1):
            self.assertEqual(lookup[(wm, f"switch-to-workspace-{index}")], f"['<Super>{key}']")
        self.assertEqual(lookup[("org.gnome.desktop.wm.preferences", "num-workspaces")], "4")
        self.assertEqual(lookup[("org.gnome.mutter", "dynamic-workspaces")], "false")
        for index in range(1, 5):
            self.assertEqual(lookup[("org.gnome.shell.keybindings", f"switch-to-application-{index}")], "@as []")

if __name__ == "__main__":
    unittest.main()
