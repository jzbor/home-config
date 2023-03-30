{ lib, stdenv, pkgs, ... }:

let
  script-name = "wallpaper-daemon";
  script-src = builtins.readFile ./wallpaper-daemon.sh;
  script = (pkgs.writeShellScriptBin script-name script-src).overrideAttrs(old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
  script-inputs = with pkgs; [
    gnugrep
    xorg.xev
    xwallpaper
  ];
in pkgs.symlinkJoin {
  name = script-name;
  paths = [ script ] ++ script-inputs;
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/${script-name} --prefix PATH : $out/bin";
}
