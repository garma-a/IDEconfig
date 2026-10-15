#!/usr/bin/env python3
"""Apply or verify the portable, allowlisted GNOME desktop profile."""
import argparse
import ast
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import time

REPO = Path(__file__).resolve().parents[1]

def run(*args):
    env = dict(os.environ)
    if args[0] in {"xdg-settings", "xdg-mime"}:
        env.pop("BROWSER", None)
    return subprocess.run(args, check=True, capture_output=True, text=True, env=env).stdout.strip()

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if not shutil.which("gsettings") or not os.getenv("DBUS_SESSION_BUS_ADDRESS") or "GNOME" not in os.getenv("XDG_CURRENT_DESKTOP", "").upper():
        print("PENDING: GNOME desktop session required. Run bash setup.sh --desktop-only from Kitty after login.")
        return 2
    schemas = set(run("gsettings", "list-schemas").splitlines())
    profile = json.loads((REPO / "desktop/gnome.json").read_text())
    changes = []
    failures = []
    for setting in profile["settings"]:
        schema, key, value = setting["schema"], setting["key"], setting["value"]
        if schema not in schemas:
            if setting.get("optional"):
                continue
            failures.append(f"Required GNOME schema unavailable: {schema}")
            continue
        if key not in run("gsettings", "list-keys", schema).splitlines():
            if setting.get("optional"):
                print(f"SKIP unavailable optional setting: {schema} {key}")
                continue
            failures.append(f"Required setting unavailable: {schema} {key}")
            continue
        current = run("gsettings", "get", schema, key)
        if current != value:
            changes.append((schema, key, value, current))
    # Own a deterministic custom binding; preserve other custom shortcuts.
    media = "org.gnome.settings-daemon.plugins.media-keys"
    path = "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ideconfig-kitty/"
    custom = "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:" + path
    current_paths = run("gsettings", "get", media, "custom-keybindings")
    paths = ast.literal_eval(current_paths.removeprefix("@as "))
    for other in paths:
        if other != path:
            other_schema = "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:" + other
            binding = run("gsettings", "get", other_schema, "binding")
            if binding in ["'<Control><Alt>t'", "'<Primary><Alt>t'", "'<Ctrl><Alt>t'"]:
                changes.append((other_schema, "binding", "''", binding))
    if path not in paths:
        changes.append((media, "custom-keybindings", repr(paths + [path]), current_paths))
    for key, value in [("name", "'Kitty'"), ("command", "'kitty'"), ("binding", "'<Control><Alt>t'")]:
        current = run("gsettings", "get", custom, key)
        if current != value:
            changes.append((custom, key, value, current))
    if failures:
        print("\n".join(failures), file=sys.stderr)
        return 1
    config = Path(os.getenv("XDG_CONFIG_HOME", str(Path.home() / ".config")))
    terminal_lists = [config / name for name in ["ubuntu-xdg-terminals.list", "gnome-xdg-terminals.list", "xdg-terminals.list"]]
    if args.check:
        failures.extend(f"Desktop setting differs: {s} {k} (expected {v}, got {old})" for s, k, v, old in changes)
        for target in terminal_lists:
            if not target.is_file() or target.read_text().splitlines()[:1] != ["kitty.desktop"]:
                failures.append(f"Kitty default missing: {target}")
        for mime in ["x-scheme-handler/http", "x-scheme-handler/https", "text/html"]:
            if run("xdg-mime", "query", "default", mime) != "google-chrome.desktop":
                failures.append(f"Chrome is not default for {mime}")
        if failures:
            print("\n".join(failures), file=sys.stderr)
            return 1
        print("Verified GNOME shortcuts, Chrome and Kitty defaults.")
        return 0
    state = Path(os.getenv("XDG_STATE_HOME", str(Path.home() / ".local/state"))) / "IDEconfig"
    state.mkdir(parents=True, exist_ok=True)
    if changes:
        backup = state / f"desktop-before-{time.time_ns()}.json"
        backup.write_text(json.dumps([{"schema": s, "key": k, "value": old} for s, k, v, old in changes], indent=2) + "\n")
        print(f"Previous desktop values: {backup}")
    for schema, key, value, old in changes:
        run("gsettings", "set", schema, key, value)
    for target in terminal_lists:
        target.parent.mkdir(parents=True, exist_ok=True)
        old = target.read_text() if target.exists() else ""
        lines = [x for x in old.splitlines() if x.strip() != "kitty.desktop"]
        new = "\n".join(["kitty.desktop"] + lines) + "\n"
        if old != new:
            if target.exists():
                shutil.copy2(target, str(target) + f".backup.{time.time_ns()}")
            target.write_text(new)
    run("xdg-settings", "set", "default-web-browser", "google-chrome.desktop")
    for mime in ["x-scheme-handler/http", "x-scheme-handler/https", "text/html"]:
        run("xdg-mime", "default", "google-chrome.desktop", mime)
    print("Applied four workspaces, captured shortcuts, Chrome and Kitty defaults.")
    return 0

if __name__ == "__main__":
    try:
        sys.exit(main())
    except (subprocess.CalledProcessError, ValueError) as exc:
        print(f"Desktop setup failed: {exc}\n{getattr(exc, 'stderr', '')}", file=sys.stderr)
        sys.exit(1)
