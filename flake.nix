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
    lib = nixpkgs.lib;

    mkHost = host: let
      username = lib.trim (builtins.readFile ./hosts/${host}/username);

      gitName = lib.trim (builtins.readFile ./hosts/${host}/git-name);
      gitEmail = lib.trim (builtins.readFile ./hosts/${host}/git-email);
    in
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit zen-browser username gitName gitEmail;
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
                inherit zen-browser username gitName gitEmail;
              };

              users.${username} = import ./home.nix;

              overwriteBackup = true;
              backupFileExtension = "backup";
            };
          }
        ];
      };
    hosts = builtins.attrNames (
      lib.filterAttrs (
        name: type:
          type == "directory"
      ) (builtins.readDir ./hosts)
    );
  in {
    nixosConfigurations = nixpkgs.lib.genAttrs hosts mkHost;
  };
}
