{ pkgs, writeShellApplication, ... }:

writeShellApplication {
  name = "mars-status";
  runtimeInputs = with pkgs; [
    gnugrep
    libcanberra-gtk3
    libnotify
    pulseaudio
    xmenu
  ];
  text = builtins.readFile ./mars-status.sh;
}
