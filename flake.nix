{
  description = "My home config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    jzbor-overlay.url = "github:jzbor/nix-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, nix-colors, jzbor-overlay, flake-utils }: {
    defaultPackage = home-manager.defaultPackage;

    homeConfigurations.jzbor = home-manager.lib.homeManagerConfiguration (
      let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system}.extend jzbor-overlay.overlays.default;
      in {
        inherit pkgs;

        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit nix-colors; };
    });

    homeConfigurations."jzbor@pinebook-pro" = home-manager.lib.homeManagerConfiguration (
      let
        system = "aarch64-linux";
        pkgs = nixpkgs.legacyPackages.${system}.extend jzbor-overlay.overlay;
      in {
        inherit pkgs;

        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit nix-colors; };
    });
  };
}
