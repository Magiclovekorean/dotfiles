{
  description = "My NixOS flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:Magiclovekorean/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tmux-project-switcher = {
      url = "github:Magiclovekorean/tmux-project-switcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    workmux = {
      url = "github:raine/workmux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    zen-browser,
    hyprland,
    tmux-project-switcher,
    spicetify-nix,
    workmux,
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
          inherit zen-browser hyprland tmux-project-switcher workmux username gitName gitEmail;
        };

        modules = [
          ./hosts/${host}/configuration.nix
          ./configuration.nix

          home-manager.nixosModules.home-manager

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              sharedModules = [
                spicetify-nix.homeManagerModules.default
              ];

              extraSpecialArgs = {
                inherit zen-browser tmux-project-switcher spicetify-nix workmux username gitName gitEmail;
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
