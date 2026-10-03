{
  config,
  pkgs,
  username,
  gitName,
  gitEmail,
  zen-browser,
  llm-agents,
  ...
}: let
  tex = pkgs.texliveMedium.withPackages (
    ps:
      with ps; [
        latexmk
        algorithms
        minted
        newtx
        diagbox
        textpos
        subfigure
        titlesec
        xpatch
        xstring
        mathdots
        cancel
      ]
  );
  dotfiles = "${config.home.homeDirectory}/Desktop/repos/dotfiles/home/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  bin_dir = ".local/bin";
in {
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";
  programs.git = {
    enable = true;
    settings.user = {
      name = gitName;
      email = gitEmail;
    };
  };
  programs.zsh = {
    enable = true;

    history = {
      path = "${config.home.homeDirectory}/.config/zsh/zhistory";
      size = 5000;
      save = 5000;
      append = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    initContent = builtins.readFile ./home/.zshrc;

    plugins = [
      {
        name = "sudo";
        src = pkgs.fetchFromGitHub {
          owner = "ohmyzsh";
          repo = "ohmyzsh";
          rev = "f8bf8f0";
          hash = "sha256-5xS5SPNnQTde/2UbOBmjKHiq+nr2Wgj4mt7cNa5m7fs=";
        };
        file = "plugins/sudo/sudo.plugin.zsh";
      }

      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }

      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }

      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }

      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
    ];
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = power-theme;
        extraConfig = ''
          set -g @tmux_power_theme 'colour6'
        '';
      }
      vim-tmux-navigator
    ];

    extraConfig = builtins.readFile ./home/.tmux.conf;
  };

  programs.rofi = {
    enable = true;
    plugins = [
      pkgs.rofi-calc
      pkgs.rofi-emoji
    ];
    theme = ./home/rofi/themes/spotlight-dark.rasi;
  };

  home.activation = {
    # Make nautilus the handler for inode/directory, so xdg-open on a folder and
    # "open containing folder" open it instead of whatever else claims the
    # mimetype. Without this they resolve to cursor.desktop.
    #
    # The desktop entry is org.gnome.Nautilus.desktop (GNOME 47+ renamed it from
    # nautilus.desktop), so xdg-mime needs that exact id. XDG_DATA_DIRS is
    # pointed at the package so the entry resolves regardless of what the
    # activation environment has on PATH.
    #
    # Deliberately not using xdg.mimeApps: that option links mimeapps.list into
    # the store read-only, which would replace the hand-maintained
    # ~/.config/mimeapps.list and break `xdg-mime set-default` for apps.
    setNautilusAsDefault = ''
      export XDG_DATA_DIRS="${pkgs.nautilus}/share:''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
      current=$(${pkgs.xdg-utils}/bin/xdg-mime query default inode/directory 2>/dev/null || true)
      if [ "$current" != "org.gnome.Nautilus.desktop" ]; then
        ${pkgs.xdg-utils}/bin/xdg-mime default org.gnome.Nautilus.desktop inode/directory || true
      fi
    '';
  };

  qt = {
    enable = true;
    platformTheme = {
      name = "kde";
      package = [
        pkgs.kdePackages.plasma-integration
        pkgs.kdePackages.plasma-integration.qt5
      ];
    };

    kde.settings = {
      kdeglobals = {
        Icons = {
          Theme = "Papirus-Dark";
        };
        General = {
          ColorScheme = "BreezeDark";
        };
        UiSettings = {
          ColorScheme = "BreezeDark";
        };
        KDE = {
          widgetStyle = "breeze";
        };
      };
    };
  };

  xdg.dataFile."color-schemes/BreezeDark.colors".source = "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
    size = 30;
    x11.enable = true;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    colorScheme = "dark";

    gtk4.extraConfig = {
      gtk-interface-color-scheme = "dark";
    };

    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

  # Nothing in this session pulls in graphical-session.target, but
  # xdg-desktop-portal.service is Requisite= it, so the portal never started and
  # libadwaita apps (Nautilus) never learned the system color scheme. Worse,
  # AdwStyleManager then overwrites GtkSettings:gtk-interface-color-scheme, so
  # gtk4.extraConfig / settings.ini could not win either. libadwaita only reads
  # org.gnome.desktop.interface itself when the portal is disabled, which is why
  # that was needed as a workaround.
  #
  # The stock unit is static with RefuseManualStart=yes and StopWhenUnneeded=yes,
  # so it can only be activated by being wanted. Redefining it here lets
  # default.target want it, which keeps it active for the whole session so the
  # portal can start and answer the Settings interface.
  #
  # Note the spelling: systemd.user.targets has no `wantedBy` option. Its type is
  # freeform attrsOf (attrsOf (either primitive (listOf primitive))), so
  # `wantedBy."default.target" = true;` type-checks and passes `nix eval` but gets
  # rendered as a literal [wantedBy] INI section instead of [Install]. Home
  # Manager builds the enablement symlink with
  #   map (install "wants") (serviceCfg.Install.WantedBy or [ ])
  # so with Install.WantedBy unset no default.target.wants symlink is created, the
  # target is never started, and `systemctl --user enable` reports "The unit files
  # have no installation config". Install.WantedBy must be a list of strings.
  systemd.user.targets.graphical-session = {
    Unit.Wants = ["xdg-desktop-portal.service"];
    Install.WantedBy = ["default.target"];
  };

  services.playerctld.enable = true;
  services.cliphist.enable = true;
  services.mako.enable = true;

  programs.hyprlock.enable = true;
  services.hyprsunset.enable = true;

  services.wpaperd.enable = true;
  services.hyprpolkitagent.enable = true;
  services.gnome-keyring.enable = true;

  systemd.user.services.input-remapper-autoload = {
    Unit.Description = "Apply input-remapper autoload presets at login";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.input-remapper}/bin/input-remapper-control --command autoload";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = ["default.target"];
  };

  home.file = builtins.mapAttrs (name: _: {
    source = ./bin/${name};
    target = "${bin_dir}/${name}";
    executable = true;
  }) (builtins.readDir ./bin);

  programs.obs-studio.enable = true;

  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (old: {
      src = pkgs.fetchFromGitHub {
        owner = "Alexays";
        repo = "Waybar";
        rev = "6d60c8e02be67bb85bb9b1ea803f2fbcf0722002";
        hash = "sha256-G6AcGuevhkYflQHhJq9GnLhEMgcI51Y6MYKBQvdRPDc=";
      };
      buildInputs = (old.buildInputs or []) ++ [pkgs.modemmanager];

      mesonFlags = (old.mesonFlags or []) ++ ["-Dcava=disabled"];
    });
  };

  programs.librewolf.enable = true;
  programs.chromium.enable = true;

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono NF:size=16";
        pad = "10x10";
      };
      cursor = {
        style = "block";
        blink = "no";
      };
      mouse = {
        hide-when-typing = "yes";
      };
      colors-dark = {
        alpha = 0.6;

        foreground = "c0caf5";
        background = "1a1b26";

        ## Normal/regular colors (color palette 0-7)
        regular0 = "15161E"; # black;
        regular1 = "f7768e"; # red;
        regular2 = "9ece6a"; # green;
        regular3 = "e0af68"; # yellow;
        regular4 = "7aa2f7"; # blue;
        regular5 = "bb9af7"; # magenta;
        regular6 = "7dcfff"; # cyan;
        regular7 = "a9b1d6"; # white;

        ## Bright colors (color palette 8-15)
        bright0 = "414868"; # bright black
        bright1 = "f7768e"; # bright red
        bright2 = "9ece6a"; # bright green
        bright3 = "e0af68"; # bright yellow
        bright4 = "7aa2f7"; # bright blue
        bright5 = "bb9af7"; # bright magenta
        bright6 = "7dcfff"; # bright cyan
        bright7 = "c0caf5"; # bright white

        ## dimmed colors (see foot.ini(5) man page)
        dim0 = "ff9e64";
        dim1 = "db4b4b";
      };
    };
  };

  programs.anki = {
    enable = true;
    style = "anki";
    theme = "dark";

    # Anki cannot persist the AnkiWeb account on its own: this module makes
    # ~/.local/share/Anki2/prefs21.db a symlink into the read-only nix store,
    # and its bundled "home-manager" addon sets `aqt.mw.pm.save = lambda: None`
    # to match. So the credentials are read from outside the store instead, and
    # the module's hm-sync-config addon re-applies them on every profile open.
    #
    # Nothing has to be created up front: the anki-persist-sync-creds addon
    # below writes both files the moment Anki accepts a login, so a machine
    # needs the AnkiWeb prompt exactly once and never asks again.
    #
    # The credentials live in ~/.config/anki, which xdg.configFile symlinks to
    # home/config/anki like every other config dir. Only the two secret files
    # are gitignored (.gitkeep is tracked so the dir survives a fresh clone), so
    # the account never lands in git. See the note in .gitignore.
    # The sync key is not the account password; see issue #19.
    profiles."User 1".sync = {
      usernameFile = "${config.home.homeDirectory}/.config/anki/sync-username";
      keyFile = "${config.home.homeDirectory}/.config/anki/sync-key";
    };

    addons = [
      pkgs.ankiAddons.review-heatmap
      pkgs.ankiAddons.passfail2

      # Mirrors a successful AnkiWeb login into the two files the module's
      # hm-sync-config addon reads back on every profile open. That addon only
      # reads, and Anki's own save is disabled by the module (prefs21.db is a
      # symlink into the read-only store), so without this the account is asked
      # for on every single launch. Anki calls set_sync_key/set_sync_username
      # right after a login succeeds (aqt/sync.py), which is the only moment
      # worth capturing.
      #
      # Both files are chmod 600 and land in home/config/anki, which is
      # gitignored file-by-file, so the account and key stay out of git.
      (pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
        pname = "anki-persist-sync-creds";
        version = "1.0";

        src = pkgs.writeTextDir "__init__.py" ''
          import os
          from pathlib import Path
          from unittest.mock import patch

          import aqt

          USERNAME_FILE = Path("${config.home.homeDirectory}/.config/anki/sync-username")
          KEY_FILE = Path("${config.home.homeDirectory}/.config/anki/sync-key")

          def persist(path: Path, value: str | None) -> None:
              # None means Anki has no account (or just logged out). Leave any
              # stored credential alone rather than blanking the file.
              if not value:
                  return
              path.parent.mkdir(parents=True, exist_ok=True)
              # Create with 0600 from the start, and never widen it on rewrite.
              fd = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
              with os.fdopen(fd, "w") as f:
                  f.write(value)

          # No self parameter: patch.object installs these on the *instance*,
          # and instance attributes are not descriptors, so they are not bound.
          def set_sync_key(val: str | None) -> None:
              persist(KEY_FILE, val)
              _orig_set_sync_key(val)

          def set_sync_username(val: str | None) -> None:
              persist(USERNAME_FILE, val)
              _orig_set_sync_username(val)

          _orig_set_sync_key = aqt.mw.pm.set_sync_key
          _orig_set_sync_username = aqt.mw.pm.set_sync_username

          # Wrap on the instance rather than the class: the module's own
          # addon replaces pm.save() the same way.
          patch.object(aqt.mw.pm, "set_sync_key", set_sync_key).start()
          patch.object(aqt.mw.pm, "set_sync_username", set_sync_username).start()
        '';
      }))

      (pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
        pname = "more-overview-stats";
        version = "2.1";

        src = pkgs.fetchFromGitHub {
          owner = "patrick-nohira";
          repo = "Anki_More_Overview_Stats";
          rev = "58242a21d1895bdba7a5a2c15781ea10132ab980";
          hash = "sha256-UFT3FBljrCC/WcLjzh61ElPcJURYYgqqQfSVh+ePK0k=";
        };
      }))
    ];
  };

  xdg.configFile = builtins.mapAttrs (name: _: {
    source = create_symlink "${dotfiles}/${name}";
    recursive = true;
  }) (builtins.readDir ./home/config);

  home.packages = with pkgs; [
    gnumake
    tree-sitter
    ripgrep
    neovim

    # Nvim LSP's
    typescript-language-server # Typescript LSP
    vscode-langservers-extracted # HTML/CSS/JSON/ESlint LSP
    tailwindcss-language-server # Tailwindcss LSP
    lua-language-server # Lua LSP
    emmet-language-server # Emmet LSP
    pyright # Python LSP
    texlab # Latex LSP
    ltex-ls-plus # Languagetool LSP
    nixd

    # Nvim formatters
    prettier
    stylua
    ruff
    alejandra

    unzip
    psmisc # Provides killall
    yazi
    fzf
    lazygit
    inotify-tools
    bluetui
    btop
    htop
    fastfetch
    gh
    hyprshutdown
    batsignal
    hypridle

    polychromatic

    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.freebuff
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode
    wlogout
    localsend
    papirus-icon-theme

    # Hyprland is not a DE Electron recognizes; without this Cursor skips the OS keyring.
    (code-cursor.override {
      commandLineArgs = "--password-store=gnome-libsecret";
    })

    pavucontrol

    ghostty

    playerctl
    brightnessctl
    xdg-desktop-portal-hyprland
    satty
    kdePackages.plasma-integration
    nautilus
    udiskie
    imv
    mpv
    vlc
    spotify
    hyprpicker
    grim
    slurp
    kdePackages.breeze
    (tesseract.override {
      enableLanguages = ["eng" "spa" "cat" "kor"];
    })
    (stdenv.mkDerivation {
      pname = "zscroll";
      version = "35c50fa";

      src = fetchFromGitHub {
        owner = "noctuid";
        repo = "zscroll";
        rev = "35c50faae2787e13649146bad216e1f6444f13b8";
        hash = "sha256-j9drC3BtQUSHlQf7FWIXBy2PUlPOwBu1sL3JR0nmHzM=";
      };

      buildInputs = [python3];

      dontBuild = true;
      dontConfigure = true;

      installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/share/man/man1
        mkdir -p $out/share/zsh/site-functions

        cp zscroll $out/bin/zscroll
        chmod +x $out/bin/zscroll

        cp zscroll.1 $out/share/man/man1/zscroll.1

        cp completion/_zscroll $out/share/zsh/site-functions/_zscroll
      '';
    })
    # Install nmrs-gui
    (rustPlatform.buildRustPackage {
      pname = "nmrs-gui";
      version = "9ff7f8f";

      src = fetchFromGitHub {
        owner = "networkmanager-rs";
        repo = "nmrs-gui";
        rev = "9ff7f8f3759e876b4488102c192a31886581020f";

        hash = "sha256-sA4D98pVdwu7vjxj4UOWBrT1GzMVxJc4ckoojmpIdaw=";
      };

      cargoHash = "sha256-/i9+33zs6wJWMZfjYhRg/SzYD0n7XuuD0FbbnOMyfQg=";

      nativeBuildInputs = [
        pkg-config
        wrapGAppsHook4
      ];

      buildInputs = [
        gtk4
        libadwaita
        networkmanager
      ];

      doCheck = false;
    })

    qt5.qtwayland
    qt6.qtwayland

    wl-clipboard

    eza
    bat
    zoxide

    pnpm
    lazygit
    nixpkgs-fmt
    nodejs
    gcc

    usbimager

    stretchly

    xournalpp
    libreoffice

    python3
    python3Packages.pip

    (zathura.override {
      useMupdf = true;
    })
    jre
    tex
    system-config-printer

    cliamp

    davinci-resolve
    proton-authenticator
  ];
}
