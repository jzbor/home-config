
{ lib, stdenv, pkgs, ... }:

let
  script-name = "nix-cleanup";
  script-src = builtins.readFile ./nix-cleanup.sh;
  script = (pkgs.writeShellScriptBin script-name script-src).overrideAttrs(old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
  script-inputs = with pkgs; [
    nix
  ];
in pkgs.symlinkJoin {
  name = script-name;
  paths = [ script ] ++ script-inputs;
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/${script-name} --prefix PATH : $out/bin";
}
