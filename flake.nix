{
  description = "My NixOS flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    zen-browser,
    ...
  }: let
    mkHost = host:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit zen-browser;
        };

        modules = [
          ./hosts/${host}/configuration.nix
          ./configuration.nix

          home-manager.nixosModules.home-manager

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              extraSpecialArgs = {
                inherit zen-browser;
              };

              users.magictt = import ./home.nix;

              overwriteBackup = true;
              backupFileExtension = "backup";
            };
          }
        ];
      };
  in {
    nixosConfigurations = {
      hp-nixos-laptop = mkHost "hp-nixos-laptop";
      hp-red-laptop = mkHost "hp-red-laptop";
    };
  };
}
