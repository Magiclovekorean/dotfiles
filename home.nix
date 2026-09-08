{
  config,
  pkgs,
  zen-browser,
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
  home.username = "magictt";
  home.homeDirectory = "/home/magictt";
  home.stateVersion = "26.05";
  programs.git = {
    enable = true;
    settings.user.name = "Martí Forn";
    settings.user.email = "magiclovekorean@gmail.com";
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
    theme = ./home/rofi/themes/squared-nord.rasi;
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";

    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };

    qt5ctSettings = {
      Appearance = {
        icon_theme = "Papirus-Dark";
        standard_dialogs = "xdgdesktopportal";
        style = "adwaita-dark";
      };
    };
    qt6ctSettings = {
      Appearance = {
        icon_theme = "Papirus-Dark";
        standard_dialogs = "xdgdesktopportal";
        style = "adwaita-dark";
      };
    };
  };

  gtk = {
    enable = true;
    colorScheme = "dark";

    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

  services.playerctld.enable = true;
  services.cliphist.enable = true;

  services.hypridle.enable = true;
  programs.hyprlock.enable = true;
  services.hyprsunset.enable = true;

  services.wpaperd.enable = true;
  services.batsignal.enable = true;
  services.hyprpolkitagent.enable = true;

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

  programs.brave-origin = {
    enable = true;
  };

  home.file = builtins.mapAttrs (name: _: {
    source = ./bin/${name};
    target = "${bin_dir}/${name}";
    executable = true;
  }) (builtins.readDir ./bin);

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
    opencode
    lazygit
    inotify-tools
    bluetui
    btop
    htop
    fastfetch
    gh
    hyprshutdown

    polychromatic

    google-chrome
    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    wlogout
    localsend
    ghostty
    rose-pine-cursor

    pavucontrol

    mako
    playerctl
    brightnessctl
    xdg-desktop-portal-hyprland
    satty
    kdePackages.dolphin
    imv
    mpv
    vlc
    spotify
    hyprpicker
    grim
    slurp
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

    pnpm
    lazygit
    nixpkgs-fmt
    nodejs
    gcc

    usbimager

    python3
    python3Packages.pip

    (zathura.override {
      useMupdf = true;
    })
    jre
    tex
  ];
}
