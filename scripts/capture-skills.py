#!/usr/bin/env python3
"""Refresh the portable custom skill snapshot from this user's known skill folders."""
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
from skills import digest

repo = Path(__file__).resolve().parents[1]
home = Path.home()
manifest_path = repo / "ai/skills-manifest.json"
previous = {s["name"]: s for s in json.loads(manifest_path.read_text())["skills"]} if manifest_path.exists() else {}
roots = [home / ".agents/skills", home / ".codex/skills", home / ".gemini/antigravity-cli/skills", home / ".config/opencode/skills"]
for profile in sorted(home.glob(".codex-account-*/skills")):
    roots.append(profile)
if os.getenv("CODEX_HOME"):
    roots.append(Path(os.environ["CODEX_HOME"]) / "skills")
lock_path = home / ".agents/.skill-lock.json"
lock = json.loads(lock_path.read_text()).get("skills", {}) if lock_path.exists() else {}
sources = {
    "playwright": "https://github.com/openai/skills/tree/main/skills/.curated/playwright",
    "security-best-practices": "https://github.com/openai/skills/tree/main/skills/.curated/security-best-practices",
    "superpowers-lab": "https://github.com/obra/superpowers-lab",
    "caveman-token-optimizer": "https://github.com/JuliusBrussee/caveman",
}
skills = {}
ignored = shutil.ignore_patterns(".git", "__pycache__", "*.pyc", ".DS_Store", ".env", ".env.*")
for root in dict.fromkeys(roots):
    if not root.is_dir():
        continue
    for source in sorted(root.iterdir()):
        if source.name.startswith(".") or not (source / "SKILL.md").is_file():
            continue
        if ".backup." in source.name:
            continue
        name = source.name
        if not re.fullmatch(r"[a-z0-9][a-z0-9-]{0,63}", name):
            raise SystemExit(f"Invalid skill folder name: {source}")
        if name in skills:
            # Preserve distinct versions explicitly instead of silently losing one.
            if digest(source) != skills[name]["sha256"]:
                raise SystemExit(f"Conflicting versions for {name}: {source}. Resolve before capture.")
            skills[name]["captured_from"].append(str(source).replace(str(home), "~", 1))
            continue
        # Export only directory bundles; reject links escaping their own bundle.
        resolved = source.resolve()
        for child in source.rglob("*"):
            if child.is_symlink() and not child.resolve().is_relative_to(resolved):
                raise SystemExit(f"External symlink requires review: {child}")
        target = repo / "ai/skills" / name
        target.parent.mkdir(parents=True, exist_ok=True)
        if target.exists() and target.resolve() != source.resolve():
            shutil.rmtree(target)
        if target.resolve() != source.resolve():
            shutil.copytree(source, target, ignore=ignored)
        record = lock.get(name, {})
        upstream = record.get("sourceUrl") or previous.get(name, {}).get("source_url") or sources.get(name)
        if record.get("skillPath"):
            upstream = upstream.removesuffix(".git") + "/blob/HEAD/" + record["skillPath"]
        skills[name] = {
            "name": name, "bundle": f"ai/skills/{name}", "sha256": digest(target),
            "source_url": upstream,
            "source_note": "Source recorded locally; bundled files preserve the installed version." if upstream else "Local/custom skill; original upstream was not recorded on this system.",
            "captured_from": [str(source).replace(str(home), "~", 1)],
        }
if not skills:
    raise SystemExit("No custom skills found; existing manifest left unchanged.")
manifest = {"version": 1, "skills": sorted(skills.values(), key=lambda x: x["name"])}
(repo / "ai/skills-manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
lines = ["# Installed custom skills", "", "Additional provider-managed skill links: [PROVIDED-SKILLS.md](PROVIDED-SKILLS.md).", "", "Portable snapshots from the source machine. Setup uses the bundled files and verifies SHA-256; upstream links are for reference, not unpinned reinstall commands.", "", "| Skill | Original source |", "| --- | --- |"]
for s in manifest["skills"]:
    source = f"[upstream]({s['source_url']})" if s["source_url"] else "Local/custom (upstream unknown)"
    lines.append(f"| [{s['name']}](skills/{s['name']}/SKILL.md) | {source} |")
lines += ["", "Codex-provided system skills come with Codex. Connector-backed plugin skills (Sites, Pets, plugin management) require their plugins and account connections; copying SKILL.md cannot recreate those tools. Install those through the client's plugin interface when available.", "", "Account profiles, API keys, MCP credentials, browser cookies and authentication caches are intentionally outside this snapshot.", ""]
(repo / "ai/README.md").write_text("\n".join(lines))
print(f"Captured {len(skills)} distinct custom skills.")
