# AGENTS.md

NixOS dotfiles repo (flake). Despite `README.md` describing an Arch + `stow` setup, the repo has migrated to NixOS (see `TODO.md`); trust `flake.nix`, not the README.

## Structure & auto-linking

- `flake.nix` defines a single system `nixosConfiguration.nixos-flake` wiring `configuration.nix` (system) + `home-manager` with `home.nix` (user `magictt`).
- `home.nix` auto-maps whole directories:
  - `home/config/*` → `~/.config/*` via out-of-store symlinks (`config.lib.file.mkOutOfStoreSymlink`)
  - `bin/*` → `~/.local/bin/*` (executable)
- These symlinks are **absolute pointers to `~/Desktop/repos/dotfiles/home/config`**, so the repo must stay at `~/Desktop/repos/dotfiles` or the links break.
- To add a new app config, drop a dir under `home/config/<name>`; it is linked to `~/.config/<name>` on next rebuild — no manual entry needed.

## Build / switch

```bash
sudo nixos-rebuild switch --flake .#nixos-flake
```

Relevant inputs pinned in `flake.lock`: `nixpkgs` (nixos-unstable), `home-manager`, `zen-browser` (passed to both system and home via `specialArgs`).

`home.nix` uses `useGlobalPkgs`/`useUserPackages` and `overwriteBackup = true` (backups get a `.backup` suffix).

## Gotchas

- `hardware-configuration.nix` is machine-specific and imported by `configuration.nix`; don't break the import.
- Deadlines/lockbox: `home/config/hypr` uses `hyprland.lua` (+ `modules/`, `scripts/`) rather than plain `hyprland.conf`.
- Nix formatter used: `alejandra`; Lua: `stylua` (installed in `home.packages`).
- `tmp/` is gitignored — safe scratch space.

## Current state

Working tree may have uncommitted changes (NixOS migration is ongoing). Check `git status` before making assumptions about committed vs. working config.
