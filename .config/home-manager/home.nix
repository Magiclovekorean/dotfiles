{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "magictt";
  home.homeDirectory = "/home/magictt";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.google-chrome
    pkgs.wlogout
    pkgs.colloid-icon-theme
    # LocalSend is a Flutter/GTK app whose closure lacks GL libraries, so wrap
    # it with mesa/libglvnd on LD_LIBRARY_PATH ("No GL implementation is available").
    (pkgs.writeShellScriptBin "localsend_app" ''
      export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [ pkgs.mesa pkgs.libglvnd ]}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      exec "${pkgs.localsend}/bin/localsend_app" "$@"
    '')
  ];

  xdg.enable = true;
  xdg.desktopEntries."LocalSend" = {
    name = "LocalSend";
    comment = "Share files to nearby devices";
    exec = "localsend_app";
    icon = "${pkgs.localsend}/share/icons/hicolor/512x512/apps/localsend.png";
    categories = [ "Network" "FileTransfer" ];
    terminal = false;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/magictt/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
     EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
