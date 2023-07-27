{ pkgs, ... }:

{
  home.packages = [
    (pkgs.callPackage ./dev-shell.nix {})
    (pkgs.callPackage ./mars-startup.nix {})
    (pkgs.callPackage ./mars-status.nix {})
    (pkgs.callPackage ./media-menu.nix {})
    (pkgs.callPackage ./nix-cleanup.nix {})
    (pkgs.callPackage ./open-document.nix {})
    (pkgs.callPackage ./riot.nix {})
    (pkgs.callPackage ./screencast.nix {})
    (pkgs.callPackage ./spotify-wm-compat.nix {})
    (pkgs.callPackage ./wallpaper-daemon.nix {})
    (pkgs.callPackage ./xdg-xmenu.nix {})

    # Packages shared by multiple scripts (to avoid collisions
    pkgs.python3
  ];
}
