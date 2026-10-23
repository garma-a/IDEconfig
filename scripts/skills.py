#!/usr/bin/env python3
"""Restore the checked-in skill bundles without needing their upstream websites."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import sys
import time

REPO = Path(__file__).resolve().parents[1]

def digest(folder):
    h = hashlib.sha256()
    for p in sorted(folder.rglob("*")):
        if p.is_file() and "__pycache__" not in p.parts and p.suffix != ".pyc" and p.name != ".DS_Store":
            h.update(p.relative_to(folder).as_posix().encode())
            h.update(b"\0")
            h.update(p.read_bytes())
    return h.hexdigest()

def destinations(home):
    result = []
    codex = shutil.which("codex") or (home / ".codex").is_dir() or bool(os.getenv("CODEX_HOME"))
    agy = shutil.which("agy") or (home / ".local/bin/agy").is_file()
    opencode = shutil.which("opencode") or (home / ".opencode/bin/opencode").is_file()
    if codex:
        result.append(("Codex (all profiles)", home / ".agents/skills"))
    else:
        print("SKIP Codex: client not installed")
    if agy:
        result.append(("Antigravity CLI", home / ".gemini/antigravity-cli/skills"))
    else:
        print("SKIP Antigravity CLI: client not installed")
    if opencode:
        result.append(("OpenCode", home / ".config/opencode/skills"))
    else:
        print("SKIP OpenCode: client not installed")
    return result

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    manifest = json.loads((REPO / "ai/skills-manifest.json").read_text())
    targets = destinations(Path.home())
    failures = []
    for skill in manifest["skills"]:
        source = REPO / skill["bundle"]
        if not (source / "SKILL.md").is_file() or digest(source) != skill["sha256"]:
            failures.append("Missing/modified bundle: " + skill["name"])
            continue
        skill_targets = list(targets)
        if skill["name"] == "playwright" and any(client.startswith("Codex") for client, _ in targets):
            # The upstream skill's helper path is CODEX_HOME/skills/playwright.
            profiles = {
                Path.home() / ".codex",
                *(p.resolve() for p in Path.home().glob(".codex-*") if p.is_dir()),
            }
            if os.getenv("CODEX_HOME"):
                profiles.add(Path(os.environ["CODEX_HOME"]).expanduser().resolve())
            skill_targets.extend(("Codex helper compatibility", profile / "skills") for profile in sorted(profiles))
        for client, root in skill_targets:
            target = root / skill["name"]
            if args.dry_run:
                print(f"{client}: {skill['name']} -> {target}")
                continue
            if args.check:
                if not target.is_dir() or digest(target) != skill["sha256"]:
                    failures.append(f"{client}: {skill['name']} missing or differs")
                continue
            if target.is_symlink() and target.resolve() == source:
                continue
            root.mkdir(parents=True, exist_ok=True)
            if target.exists() or target.is_symlink():
                backup = root.parent / "skill-backups" / (target.name + f".backup.{time.time_ns()}")
                backup.parent.mkdir(parents=True, exist_ok=True)
                target.rename(backup)
                print(f"Backed up {target} -> {backup}")
            target.symlink_to(source, target_is_directory=True)
    if failures:
        print("\n".join(failures), file=sys.stderr)
        return 1
    print(f"{'Verified' if args.check else 'Planned' if args.dry_run else 'Restored'} {len(manifest['skills'])} skill bundles for {len(targets)} installed clients.")
    return 0

if __name__ == "__main__":
    sys.exit(main())
