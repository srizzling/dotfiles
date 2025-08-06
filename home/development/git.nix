{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    
    # These will be overridden by host-specific configs
    # Default/fallback identity (can be overridden per host)
    userName = lib.mkDefault "srizzling";
    userEmail = lib.mkDefault "user@example.com";  # Override this in host configs
    
    # Core git settings
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      
      core = {
        editor = "code --wait";
        # pager is set automatically by delta.enable
        autocrlf = false;
      };
      
      push = {
        autoSetupRemote = true;
        default = "simple";
      };
      
      pull = {
        rebase = true;
      };
      
      rebase = {
        autoSquash = true;
        autoStash = true;
      };
      
      merge = {
        conflictstyle = "diff3";
      };
      
      diff = {
        colorMoved = "default";
      };
      
      # Delta configuration is handled by programs.git.delta.options
    };
    
    # Git aliases
    aliases = {
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
      
      # Conventional commit helpers (complement git-emoji plugin)
      fixup = "commit --fixup";
      amend = "commit --amend --no-edit";
      
      # Branch management
      cleanup = "!git branch --merged | grep -v '\\*\\|main\\|master' | xargs -n 1 git branch -d";
    };
  };
  
  # Delta (better git diff)
  programs.git.delta = {
    enable = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = true;
    };
  };
}