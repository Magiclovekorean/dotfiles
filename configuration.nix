{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
  };

  networking.hostName = "nixos-hp";

  networking.networkmanager.enable = true;

  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "lz4";
    memoryPercent = 50;
  };

  hardware.bluetooth.enable = true;

  time.timeZone = "Europe/Madrid";

  nixpkgs.config.allowUnfree = true;

  security.polkit.enable = true;
  # pkexec needs the setuid wrapper for input-remapper's GUI
  # (pkexec not setuid root -> "pkexec must be setuid root", exit 32512)
  security.polkit.enablePkexecWrapper = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "es";
  };

  programs.zsh.enable = true;

  programs.bash = {
    enable = true;

    promptInit = ''
      PS1='\[\e[38;5;75m\]\u@\h \[\e[38;5;113m\]\w \[\e[38;5;189m\]\$\[\e[0m\] '
    '';
  };

  # Enables Gnome Keyring to store secrets for applications
  services.gnome.gnome-keyring.enable = true;

  services.displayManager.ly.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;

    pulse.enable = true;

    jack.enable = true;
  };

  security.sudo.extraRules = [
    {
      users = ["magictt"];
      commands = [
        {
          command = "/home/magictt/.local/bin/toggle-airplane";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.magictt = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  hardware.openrazer.enable = true;
  hardware.openrazer.users = ["magictt"];
  services.input-remapper.enable = true;

  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    dejavu_fonts
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "26.05"; # Do NOT modfy this
}
