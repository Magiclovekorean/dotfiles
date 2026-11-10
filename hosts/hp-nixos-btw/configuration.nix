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
      efiSupport = true;
      device = "nodev";
      copyKernels = false;
      useOSProber = true;
      configurationLimit = 10;
      default = 2;
    };
  };
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/003AE5583AE54B6C";
    fsType = "ntfs3";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "umask=022"
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
    ];
  };

  networking.hostName = "hp-nixos-btw";

  boot.kernelModules = ["snd-aloop"];

  # Intel Iris Xe (TigerLake-LP GT2) OpenCL: ocl-icd loader + NEO compute runtime
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      ocl-icd
      intel-compute-runtime
      intel-media-driver
      vpl-gpu-rt
    ];
  };
}
