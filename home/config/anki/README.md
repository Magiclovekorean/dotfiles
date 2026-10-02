# AnkiWeb credentials

`sync-username` and `sync-key` land here at runtime and are read back by
`programs.anki.profiles."User 1".sync` in `home.nix`. Neither is tracked; see
`.gitignore`.

Home Manager's Anki module symlinks `~/.local/share/Anki2/prefs21.db` into the
read-only nix store and its bundled `home-manager` addon sets
`aqt.mw.pm.save = lambda: None`, so Anki cannot save a login itself. The
module's `hm-sync-config` addon only *reads* the two files above; the
`anki-persist-sync-creds` addon in `home.nix` is what writes them, the moment
Anki accepts a login. Log in to AnkiWeb once and it is never asked again.

The sync key is not the account password, and Anki never shows it again after a
successful login. Losing these files therefore means logging in to AnkiWeb once
more to obtain a new key — see issue #19.

## Why this README exists

This directory is a git-tracked placeholder. Home Manager maps `home/config/*`
onto `~/.config/*` with `builtins.readDir`, and Nix's `git+file` flake source
only sees tracked files. With the directory empty and ignored, `readDir` cannot
see it and evaluation fails with "To make it visible to Nix, run: git add
home/config".

Two ways to get that wrong:

- Ignore the whole directory (`home/config/anki/`) and it disappears from the
  flake source.
- `git add -f` it into existence, which commits the real credentials.

Tracking a file such as this one, and ignoring only `sync-username` and
`sync-key`, is the combination that works on a fresh clone.

## Beware `git clean`

`git clean -xdf` deletes both credential files, since they are ignored. The
sync key cannot be recovered from disk afterwards; logging in to AnkiWeb again
is the only way to get a new one.