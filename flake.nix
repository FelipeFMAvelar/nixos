{
  description = "Felipe's NixOS configuration";

  nixConfig = {
    extra-substituters = [ "https://playit-nixos-module.cachix.org" ];
    extra-trusted-public-keys = [
      "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.7.0";
    llm-agents.url = "github:numtide/llm-agents.nix";
    playit-nixos-module.url = "github:pedorich-n/playit-nixos-module";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-flatpak,
      llm-agents,
      playit-nixos-module,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          nix-flatpak.nixosModules.nix-flatpak
          playit-nixos-module.nixosModules.default
          ./flatpak.nix
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              inherit llm-agents playit-nixos-module;
            };
            home-manager.users.felipe = import ./home-manager/felipe.nix;
          }
        ];
      };
    };
}
