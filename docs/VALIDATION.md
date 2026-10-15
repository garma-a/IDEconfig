# Validation

Validated on 2026-10-15 using an isolated Ubuntu 24.04 amd64 container with a separate user/home and private D-Bus session.

- Full setup completed with exit 0 after fixes and retrying interrupted downloads.
- All 60 plugin lockfile entries exactly match the repository, including Lazy itself.
- All 23 required Mason packages and 21 Go helpers are installed.
- All 28 configured Treesitter languages load successfully.
- GNOME workspace bindings, Chrome defaults and Kitty defaults pass read-back checks.
- Kitty configuration parses with Ubuntu's packaged Kitty.
- TypeScript, Python, Lua, Zig, Go, C# and DBML language servers initialize and attach. TypeScript answers a hover request.
- Five local integration tests pass, covering skill restoration, backups, repeat runs, absent clients and real GNOME settings in an isolated home/session.

The native TypeScript server logs a cancellation warning during test shutdown; initialization, attachment and the hover request pass. Physical keyboard events and GPU rendering require the actual desktop. Account sign-ins remain user actions.

The test container needed public DNS after its inherited resolver stopped responding. Host DNS and desktop settings were not changed.
