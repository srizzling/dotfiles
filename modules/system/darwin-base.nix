{ config, pkgs, lib, ... }:

{
  # Enable nix daemon
  services.nix-daemon.enable = true;
  
  # Nix configuration
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "@admin" ];
    };
  };

  # Programs
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # macOS system defaults
  system.defaults = {
    # Dock settings
    dock = {
      autohide = true;                    # Hide dock automatically
      tilesize = 32;                      # Smaller dock icons
      magnification = false;              # Disable magnification
      show-recents = false;               # Don't show recent apps
      static-only = true;                 # Only show running apps
      mru-spaces = false;                 # Don't auto-rearrange spaces
      minimize-to-application = true;     # Minimize into app icon
      launchanim = false;                 # Disable launch animation
      autohide-delay = 0.0;               # No delay before hiding
      autohide-time-modifier = 0.5;       # Faster animation
    };

    # Global system settings
    NSGlobalDomain = {
      # DISABLE natural scrolling
      "com.apple.swipescrolldirection" = false;
      
      # File extensions and UI
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Always";
      
      # Keyboard settings
      InitialKeyRepeat = 14;              # Faster key repeat start
      KeyRepeat = 1;                      # Faster key repeat rate
      
      # Disable annoying auto-features
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
    };

    # Finder settings
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXDefaultSearchScope = "SCcf";      # Search current folder
      FXEnableExtensionChangeWarning = false;
      _FXShowPosixPathInTitle = true;     # Show full path in title
    };

    # Menu bar clock
    menuExtrasClock = {
      ShowSeconds = true;
      ShowDayOfWeek = true;
    };

    # Screenshots
    screencapture = {
      location = "~/Pictures/Screenshots";
      type = "png";
    };

    # Login window
    loginwindow = {
      GuestEnabled = false;
      LoginwindowText = "Managed by Nix";
    };

    # Trackpad
    trackpad = {
      Clicking = true;                   # Tap to click
      TrackpadThreeFingerDrag = true;    # Three finger drag
    };
  };

  # Homebrew integration for GUI apps
  homebrew = {
    enable = true;
    
    # GUI applications not available in nixpkgs or better via brew
    casks = [
      "aerospace"
      "ghostty"
      "discord"
      "raycast"
      "microsoft-teams"
      "whatsapp"
    ];
    
    # Keep homebrew clean - no formulae (use Nix instead)
    brews = [ ];
  };

  # Auto-upgrade nix package and daemon
  services.nix-daemon.enable = true;
}