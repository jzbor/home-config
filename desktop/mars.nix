{ pkgs, ... }:

{
  imports = [
    ../programs/marswm
    ../programs/rofi
    ../programs/touchegg
    ../programs/xmenu
  ];

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
      [ -f ~/.screenlayout/default.sh ] && /bin/sh ~/.screenlayout/default.sh;
      xwallpaper --daemon --zoom ~/.background-image &
      command -v solaar > /dev/null && solaar -w hide &
      marsbar &
      touchegg &
      buttermilk &
      xset -dpms
    '';
    #windowManager.command = "${pkgs.marswm}/bin/marswm";
    #initExtra = "${pkgs.buttermilk}/bin/buttermilk &";
  };
}

