# AGENTS.md

NixOS dotfiles repo (flake). `flake.nix` **auto-discovers hosts**: every directory under `hosts/` becomes a `nixosConfiguration` (built via `genAttrs` over `readDir`). No flake edit needed to add a host. `README.md` is the (stale-ish) install guide; trust `flake.nix` and `configuration.nix`.

## Structure

- Each `hosts/<host>/configuration.nix` holds host-only settings (imports its own `hardware-configuration.nix`); shared system options live in `configuration.nix`; home-manager config (`user magictt`) in `home.nix`.
- `home.nix` auto-maps whole directories:
  - `home/config/*` → `~/.config/*` via out-of-store symlinks (`config.lib.file.mkOutOfStoreSymlink`) — add a config by dropping a dir under `home/config/<name>`, no manual entry.
  - `bin/*` → `~/.local/bin/*` (executable).
- Symlinks are **absolute pointers to `~/Desktop/repos/dotfiles/home/config`** — the repo must stay at that path or the links break.
- NOT auto-linked, edited in place: `home/.zshrc` and `home/.tmux.conf` are inlined into `home.nix` via `builtins.readFile`; `home/rofi/*` is referenced directly.
- `home/config/opencode` is **opencode's own global config** (agents/, commands/, plugin deps) symlinked to `~/.config/opencode`, not an app dotdir.

## Build / switch

```bash
sudo nixos-rebuild switch --flake .#hp-nixos-laptop   # or .#hp-red-laptop
```

- The zsh aliases `nrs` / `nix-upgrade` (in `home/.zshrc`) instead resolve the host from `~/ .hostname`: `nixos-rebuild switch --flake .#$(< /home/magictt/.hostname)`. Prefer those aliases; the hostname is not committed anywhere else.
- `hosts/example/` is the install template copied by `autoSetup.sh` — it imports a missing `hardware-configuration.nix`, so it is not a buildable host.
- Inputs pinned in `flake.lock`: `nixpkgs` (nixos-unstable), `home-manager`, `zen-browser` (via `specialArgs`/`extraSpecialArgs`). `home-manager` uses `useGlobalPkgs`/`useUserPackages`, `overwriteBackup = true`, `backupFileExtension = "backup"`.
- Formatters: Nix → `alejandra`, Lua → `stylua` (both in `home.packages`).

## Install flow

- `autoSetup.sh` (driven from the NixOS ISO): copies `hosts/example` → `hosts/<hostname>`, generates `hardware-configuration.nix` from `/mnt`, writes the hostname to `~/.hostname`, then runs `nixos-install --flake .#<hostname>` and sets the `magictt` password (use `nixos-generate-config --root /mnt`).
- Known bug: an "Enter username" prompt later echoes `$username` **into `~/.hostname`**, overwriting the hostname the `nrs` alias depends on. If `~/.hostname` stops matching a `hosts/` dir, rebuild aliases break.

## Gotchas

- Two branches exist: `main` holds the current NixOS flake setup; `origin/arch` keeps the pre-migration Arch + `stow` dotfiles (they diverged at `e1be3c8`). `arch` is legacy/reference only — make changes on `main`.
- `sudo` NOPASSWD applies only to `/home/magictt/.local/bin/toggle-airplane` — don't extend without justification.
- Username (`magictt`), git identity (Martí Forn / magiclovekorean@gmail.com), and home dir are hardcoded; making them choosable is open TODO work (`TODO.md`).
- `home/config/hypr` uses `hyprland.lua` (+ hyprlock/hypridle confs), not `hyprland.conf`.
- `tmp/` is gitignored — safe scratch space.
- `home.nix` pins rev+hash for several `fetchFromGitHub` / Cargo deps (waybar, zscroll, nmrs-gui, ohmyzsh `sudo` plugin); bump the lock-style hashes when upgrading.
- Working tree may have uncommitted changes; check `git status` before assuming what's committed.