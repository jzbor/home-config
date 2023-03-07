{ pkgs, ... }:

{
  home.packages = [
    (pkgs.callPackage ./mars-status.nix {})
    (pkgs.callPackage ./spotify-wm-compat.nix {})
  ];
}
