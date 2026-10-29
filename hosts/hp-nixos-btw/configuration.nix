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
    systemd-boot = {
      enable = true;
      consoleMode = "keep";
    };
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "hp-nixos-btw";
}
