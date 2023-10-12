{ pkgs, writeShellApplication, ... }:

writeShellApplication {
  name = "media-menu";
  runtimeInputs = with pkgs; [
    gnugrep
    playerctl
    xmenu
  ];
  text = builtins.readFile ./media-menu.sh;
}
