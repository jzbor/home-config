{ lib, stdenv, pkgs, ... }:

let
  script-name = "mars-status";
  script-src = builtins.readFile ./mars-status.sh;
  script = (pkgs.writeShellScriptBin script-name script-src).overrideAttrs(old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
  script-inputs = with pkgs; [
    # coreutils
    gnugrep
    libcanberra-gtk3
    libnotify
    pulseaudio
    xmenu
  ];
in pkgs.symlinkJoin {
  name = script-name;
  paths = [ script ] ++ script-inputs;
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/${script-name} --prefix PATH : $out/bin";
}
