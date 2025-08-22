{ config, pkgs, ... }:

{
  # Configure Ghostty terminal
  home.file.".config/ghostty/config".text = ''
    # Font configuration
    font-family = Iosevka NFM
    font-family-bold = Iosevka NFM
    font-family-italic = Iosevka NFM
    font-family-bold-italic = Iosevka NFM
    font-size = 23
    
    # Use Rose Pine theme
    theme = rose-pine
    
    # Window padding for better visual appearance
    window-padding-x = 10
    window-padding-y = 10
    
    # Enable smooth cursor animation
    cursor-style = block
    cursor-style-blink = true
    
    # macOS specific settings
    macos-option-as-alt = true
    macos-non-native-fullscreen = true
  '';
}