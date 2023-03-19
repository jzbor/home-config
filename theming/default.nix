{ pkgs, nix-colors, ... }:

{
  imports = [
    ./toolkits.nix
    ./xresources.nix
  ];

  # Color scheme
  colorScheme =
    let name = "mankai";
    in nix-colors.lib-core.schemeFromYAML "${name}" (builtins.readFile ./colorschemes/${name}.yaml);
}
