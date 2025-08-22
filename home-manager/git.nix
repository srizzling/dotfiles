{ config, pkgs, profile, ... }:

{
  # Git configuration
  programs.git = {
    enable = true;
    
    # Basic configuration (profile-specific user info comes from profiles/)
    extraConfig = {
      init.defaultBranch = "main";
      push.default = "simple";
      push.autoSetupRemote = true;
      pull.rebase = true;
      rebase.autosquash = true;
      
      # Delta configuration for better diffs
      core = {
        editor = "code --wait";
        pager = "delta";
      };
      
      interactive.diffFilter = "delta --color-only";
      
      delta = {
        navigate = true;
        light = false;
        line-numbers = true;
        side-by-side = true;
        syntax-theme = "Dracula";
        # Rose Pine inspired colors for delta elements
        line-numbers-left-style = "#6e6a86";
        line-numbers-right-style = "#6e6a86";
        line-numbers-minus-style = "#eb6f92";
        line-numbers-plus-style = "#31748f";
        line-numbers-zero-style = "#6e6a86";
        minus-style = "syntax #403d52";
        minus-emph-style = "syntax #524f67";
        plus-style = "syntax #26233a";
        plus-emph-style = "syntax #403d52";
        hunk-header-style = "file line-number syntax";
        hunk-header-decoration-style = "#908caa box";
        file-style = "#c4a7e7";
        file-decoration-style = "#c4a7e7 ul";
      };
      
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";

      # Include files for different contexts
      include.path = "~/.gitconfig.local";
      
      # Directory-based configuration
      "includeIf \"gitdir:~/development/personal/\"".path = "~/.gitconfig.personal";
      "includeIf \"gitdir:~/development/work/\"".path = "~/.gitconfig.work";
    };

    # Git aliases
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      ca = "commit --amend";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
      
      # More advanced aliases
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      fixup = "!git log -n 50 --pretty=format:'%h %s' --no-merges | fzf | cut -c -7 | xargs -o git commit --fixup";
      
      # Workflow aliases
      sweep = "!git branch --merged | grep -v '\\*\\|main\\|master' | xargs -n 1 git branch -d";
      recent = "branch --sort=-committerdate";
    };
  };

  # Delta package for better git diffs
  home.packages = with pkgs; [ delta ];
}