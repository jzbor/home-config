{ pkgs, lib, config, ... }:

{
  programs.zsh = {
    enable = true;

    # Search, completion and suggestions
    historySubstringSearch.enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;

    # History
    history = {
      expireDuplicatesFirst = true;
      extended = false;  # save timestamps
      ignoreDups = true;  # ignore duplicate entries
      ignoreSpace = true;  # ignore commands starting with a space

      path = "${config.xdg.dataHome}/zsh/zsh_history";
      save = 10000;  # number of lines to save
      size = 10000;  # number of lines to keep
      share = true;  # share history between sessions
    };

    dotDir = ".config/zsh";

    # Highlighting
    enableSyntaxHighlighting = true;

    # Aliases
    shellAliases = {
      rgrep = "grep -RHIni --exclude-dir .git --exclude tags --color";
      valgrind = "valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes";
      pin-nix-shell = "nix-instantiate shell.nix --indirect --add-root shell.drv";
      installed-nixos-packages = "nix path-info -shr /run/current-system | sort -hk2";
      installed-profile-packages = "nix path-info -shr \"$HOME/.nix-profile\" | sort -hk2";
      stored-nix-pkgs = "find /nix/store -maxdepth 1 | xargs du -sh | sort -h";
    };

    # Prompt
    localVariables."PROMPT" = "\n%F{magenta}[%f%n%F{magenta}@%M]%f %F{blue}%~ %f";

    # Additional configuration
    initExtra = builtins.concatStringsSep "\n" [
      (builtins.readFile ./config.zsh)
      (builtins.readFile ./rprompt.zsh)
    ];

  };
}
