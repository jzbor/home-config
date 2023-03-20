{ config, pkgs, nix-colors, ... }: {
  imports = [
    nix-colors.homeManagerModule
    ./scripts

    ./desktop
    ./desktop/mars.nix

    ./programs/neovim
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    username = "jzbor";
    homeDirectory = "/home/jzbor";
    stateVersion = "22.11";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "buttermilk";
  };

  home.file = {
    Documents.source = config.lib.file.mkOutOfStoreSymlink "/home/jzbor/Nextcloud/jzbor/Documents";
    Music.source = config.lib.file.mkOutOfStoreSymlink "/home/jzbor/Nextcloud/jzbor/Music";
    Pictures.source = config.lib.file.mkOutOfStoreSymlink "/home/jzbor/Nextcloud/jzbor/Pictures";
  };

  home.packages = with pkgs; [
    foliot
    tldr
    yt-dlp

    # unfree programs
    spotify
    discord

    # fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
  ];

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  # enable fontconfig and make fonts discoverable
  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;
  programs.home-manager.path = "$HOME/Desktop/home-config";

  # Management of XDG base directories
  xdg.enable = true;
}
