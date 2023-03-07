{ pkgs, ... }:

{
  xdg.configFile."touchegg/touchegg.conf".source = ./touchegg.conf;
}
