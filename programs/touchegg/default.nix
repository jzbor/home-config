{ pkgs, ... }:

{
  home.packages = with pkgs; [ touchegg ];

  xdg.configFile."touchegg/touchegg.conf".source = ./touchegg.xml;
}
