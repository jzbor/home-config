{ pkgs, ... }:

let
  lockScript = pkgs.writeScriptBin "lock-screen" "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 100 2";
in {
  imports = [
    ../programs/buttermilk
    ../programs/marswm
    ../programs/rofi
    ../programs/skippy-xd
    ../programs/touchegg
    ../programs/xmenu
  ];

  home.packages = with pkgs;
  let
    thunarPlugins = with xfce; [ thunar-archive-plugin thunar-volman ];
  in [
    gthumb
    gnome.file-roller
    pavucontrol
    (xfce.thunar.override { thunarPlugins = thunarPlugins; })
    xclip
    xorg.xev
    xorg.xkill
    xorg.xprop

    lockScript
  ];

  # Set default applications
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications =
    let
      imageViewers = [ "org.gnome.gThumb.desktop" ];
      fileBrowsers = [ "thunar.desktop" "pcmanfm.desktop" ];
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
    lockCmd = "${lockScript}/bin/lock-screen";

    # disable automatic screen locking
    inactiveInterval = 10000;
    xss-lock.screensaverCycle = 10000;
  };
  xdg.desktopEntries.lock-screen = {
    name = "Lock Screen";
    exec = "lock-screen";
    categories = [ "System" "Utility" ];
    icon = "system-lock-screen";
  };

  xsession = {
    enable = true;
    #windowManager.command = "marswm";
    initExtra = ''
      command -v solaar > /dev/null && solaar -w hide &
    '';
    #windowManager.command = "${pkgs.marswm}/bin/marswm";
    #initExtra = "${pkgs.buttermilk}/bin/buttermilk &";
  };
}

