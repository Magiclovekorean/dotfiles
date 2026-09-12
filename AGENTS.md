# AGENTS.md

NixOS dotfiles repo (flake). Despite `README.md` describing an Arch + `stow` setup, the repo has migrated to NixOS (see `TODO.md`); trust `flake.nix`, not the README.

## Structure

- `flake.nix` defines **two hosts** via `mkHost`: `hp-nixos-laptop` and `hp-red-laptop`. Each wires `hosts/<host>/configuration.nix` (host-specific + `hardware-configuration.nix`), the shared `configuration.nix` (system), and home-manager with `home.nix` (user `magictt`).
- Shared system config → `configuration.nix`; host-only config (incl. `hardware-configuration.nix`) → `hosts/<host>/`. When adding system settings, decide which layer they belong in.
- `home.nix` auto-maps whole directories:
  - `home/config/*` → `~/.config/*` via out-of-store symlinks (`config.lib.file.mkOutOfStoreSymlink`)
  - `bin/*` → `~/.local/bin/*` (executable)
- These symlinks are **absolute pointers to `~/Desktop/repos/dotfiles/home/config`**, so the repo must stay at `~/Desktop/repos/dotfiles` or the links break.
- To add a new app config, drop a dir under `home/config/<name>`; it is linked on next rebuild — no manual entry needed.

## Build / switch

```bash
sudo nixos-rebuild switch --flake .#hp-nixos-laptop   # or .#hp-red-laptop
```

- inputs pinned in `flake.lock`: `nixpkgs` (nixos-unstable), `home-manager`, `zen-browser` (system via `specialArgs`, home via `extraSpecialArgs`).
- `home.nix` uses `useGlobalPkgs`/`useUserPackages` and `overwriteBackup = true` (backups get a `.backup` suffix).
- Formatters: Nix → `alejandra`, Lua → `stylua` (both in `home.packages`).

## Gotchas

- `sudo` is configured for NOPASSWD on `/home/magictt/.local/bin/toggle-airplane` only — don't extend that rule without justification.
- `home/config/hypr` uses `hyprland.lua` (+ hyprlock/hypridle confs) rather than plain `hyprland.conf`.
- `tmp/` is gitignored — safe scratch space.
- Repo relies on pinned hashes for several `fetchFromGitHub` / Cargo deps in `home.nix` (waybar, zscroll, nmrs-gui); bump the lock-style hashes when upgrading.

## Current state

Working tree may have uncommitted changes (multi-host migration is ongoing). Check `git status` before making assumptions about committed vs. working config.