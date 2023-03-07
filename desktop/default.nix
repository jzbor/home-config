{ pkgs, ... }:

{
  imports = [
    ../programs/fontconfig

    ../programs/firefox
    ../programs/thunderbird
    ../programs/mpv

    ../theming
  ];
}

