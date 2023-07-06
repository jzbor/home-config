{ lib, stdenv, pkgs, ... }:

let
  script-name = "riot";
  script-src = builtins.readFile ./riot.sh;
  script = (pkgs.writeShellScriptBin script-name script-src).overrideAttrs(old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
  script-inputs = with pkgs; [
    bc
    marswm
    slop
    xdo
    xmenu
    xorg.xwininfo
  ];
in pkgs.symlinkJoin {
  name = script-name;
  paths = [ script ] ++ script-inputs;
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/${script-name} --prefix PATH : $out/bin";
}
