{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    (if builtins.pathExists ./hardware-configuration.nix then ./hardware-configuration.nix else { })
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "changeme-host";
}
