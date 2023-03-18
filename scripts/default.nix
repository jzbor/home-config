{ pkgs, ... }:

{
  home.packages = [
    (pkgs.callPackage ./mars-status.nix {})
    (pkgs.callPackage ./media-menu.nix {})
    (pkgs.callPackage ./spotify-wm-compat.nix {})
  ];
}
