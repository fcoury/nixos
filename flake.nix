{
  description = "Felipe's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      "nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	modules = [
	  ./configuration.nix

	  home-manager.nixosModules.home-manager
	  {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;

	    home-manager.users.fcoury = import ./home.nix { inherit inputs; };
	  }
	];
      };
    };

    packages.x86_64-linux.fcoury-nvim = nixpkgs.legacyPackages.x86_64-linux.vimUtils.buildVimPlugin {
        name = "FelipeNVim";
        src = ./config/nvim;
    };
  };
}
