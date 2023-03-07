{ pkgs, ... }:

{
  imports = [
    ../programs/marswm
    ../programs/rofi
    ../programs/touchegg ];

  home.packages = with pkgs; [
    pavucontrol
    xclip
    xorg.xev
    xorg.xkill
    xorg.xprop
    xwallpaper

    # Required by status script
    pulseaudio
  ];


  services.gnome-keyring.enable = true;
  services.gpg-agent.enable = true;
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;
  services.flameshot.enable = true;

  services.picom = {
    enable = true;
    backend = "egl";
    vSync = true;
  };

  services.screen-locker = {
    enable = true;
    xautolock.enable = false;  # time based locking
    lockCmd = "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 100 2";

    # disable automatic screen locking
    inactiveInterval = 10000;
    xss-lock.screensaverCycle = 10000;
  };

  xsession = {
    enable = true;
    #windowManager.command = "marswm";
    initExtra = ''
      buttermilk &
      marsbar &
      touchegg &
      xwallpaper --daemon --zoom ~/.background-image &
      xset -dpms
    '';
    #windowManager.command = "${pkgs.marswm}/bin/marswm";
    #initExtra = "${pkgs.buttermilk}/bin/buttermilk &";
  };
}

