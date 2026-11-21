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

  networking.hostName = "hp-nixos-btw";

  boot.kernelModules = ["vmd" "snd-aloop"];
  boot.initrd.kernelModules = ["vmd"];

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

  # Ollama: force CPU-only (Intel Iris Xe has no VRAM for 18GB models, causes ErrorDeviceLost)
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cpu;
  };
}
