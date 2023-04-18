{ pkgs, ... }:

{
  imports = [
    ../programs/marswm
    ../programs/rofi
    ../programs/touchegg
    ../programs/xmenu
  ];

  home.packages = with pkgs; [
    gthumb
    pavucontrol
    pcmanfm
    xclip
    xorg.xev
    xorg.xkill
    xorg.xprop
  ];

  # Set default applications
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications =
    let
      imageViewers = [ "org.gnome.gthumb.desktop" ];
      fileBrowsers = [ "pcmanfm.desktop" ];
      pdfReaders = [ "org.pwmt.zathura.desktop" "org.gnome.Evince.desktop" ];
    in {
      "inode/directory" = fileBrowsers;

      "image/gif" = imageViewers;
      "image/jpeg" = imageViewers;
      "image/png "= imageViewers;
      "image/svg" = imageViewers;
      "image/webp" = imageViewers;

      "application/pdf" = pdfReaders;
  };


  services.gnome-keyring.enable = true;
  services.gpg-agent.enable = true;
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;

  services.picom = {
    enable = true;
    package = pkgs.picom;
    backend = "glx";
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
      wallpaper-daemon &
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

