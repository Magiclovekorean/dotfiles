{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    (builtins.pathExists ./hardware-configuration.nix && ./hardware-configuration.nix || { })
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "<HOSTNAME>";
}
