
{ pkgs, config, ... }:

{
  # Add rofi program to environment
  programs.rofi.enable = true;

  programs.rofi.theme = ./theme.rasi;
  xdg.configFile."rofi/theme.rasi".text = builtins.concatStringsSep "\n" [
    '' * {
      test:            #${config.colorScheme.colors.base00};
      background:      #1c1c1c;
      argbbackground:  #1c1c1c80;
      backgroundlight: #6c6c6c;
      transparent:     #00000000;
      foreground:      #bcbcbc;
      urgent:          #5f875f;
      selected:        #af5f5f;
    } ''
    (builtins.readFile ./theme.rasi)
  ];

  programs.rofi.extraConfig = {
    modi = "drun,ssh";
    font = "FiraCode Nerd Font 14";
    show-icons = true;
    icon-theme = "Numix-Circle";
    drun-display-format = "{name} \\n<span weight= 'light' size='small'><i>{comment}</i></span>";
    sidebar-mode = true;
    disable-history = false;
  };

  # TODO switch when buttermilk overlay is available in flake
  programs.rofi.terminal = "${pkgs.buttermilk}/bin/buttermilk";
}
