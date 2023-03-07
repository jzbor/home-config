{ pkgs, nix-colors, ... }:

{
  imports = [
    ./toolkits.nix
    ./xresources.nix
  ];

  # Color scheme
  colorScheme = nix-colors.lib-core.schemeFromYAML "apprentice" (builtins.readFile ./colorschemes/apprentice.yaml);
}
