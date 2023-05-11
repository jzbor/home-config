{ lib, stdenv, pkgs, ... }:

let
  script-name = "spotify-wm-compat";
  script-src = builtins.readFile ./spotify-wm-compat.sh;
  script = (pkgs.writeShellScriptBin script-name script-src).overrideAttrs(old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
  script-inputs = with pkgs; [
    marswm
    # coreutils
    # spotify  # removed to avoid impurity
    xdotool
  ];
in pkgs.symlinkJoin {
  name = script-name;
  paths = [ script ] ++ script-inputs;
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/${script-name} --prefix PATH : $out/bin";
}
