{ config, pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;
    
    # Fish plugins (reduced from 15 to 5)
    plugins = [
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
          sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
        };
      }
      {
        name = "autopair";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "autopair.fish";
          rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
          sha256 = "qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqrFN+LkWRM=";
        };
      }
      {
        name = "fzf-fish";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "8920367cf85eee5218cc25a11e209d46e2591e7a";
          sha256 = "T8KYLA/r/gOKvAivKRoeqRrKImFwm7cW64h+KSZUaxg=";
        };
      }
      {
        name = "catppuccin-fish";
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "fish";
          rev = "0ce27b518e8ead555dec34dd8be3df5bd75cff8e";
          sha256 = "Dc/zdxfzAUM5NX8PxzfljRbYvO9f9syuLO8yBr+R3qg=";
        };
      }
    ];

    # Shell initialization
    shellInit = ''
      # Set Catppuccin Macchiato theme
      fish_config theme save "Catppuccin Macchiato" 2>/dev/null || true
      
      # Initialize zoxide (better than z)
      zoxide init fish | source
    '';

    # Fish functions
    functions = {
      # Add custom functions here if needed
    };

    # Shell aliases
    shellAliases = {
      # Common aliases
      ll = "ls -la";
      la = "ls -la";
      
      # Git aliases (complement git-emoji plugin)
      gs = "git status";
      gd = "git diff";
      gl = "git log --oneline --graph";
    };
  };
}