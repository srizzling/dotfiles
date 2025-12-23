#!/usr/bin/env fish
# Fishtape tests for Fish shell configuration

# Test Fish aliases
@test "ll alias works" (alias ll | string match -q "*lsd -la*")
@test "la alias works" (alias la | string match -q "*lsd -a*") 
@test "gs alias works" (alias gs | string match -q "*git status*")
@test "gd alias works" (alias gd | string match -q "*git diff*")
# OrbStack provides native docker - no alias needed

# Test Fish functions - cleaned up per user request  
@test "fish_greeting function removed" (not functions -q fish_greeting)
@test "gst function removed" (not functions -q gst)

# Test Fish PATH configuration  
@test "fish_add_path is available" (which fish_add_path)
@test "Nix binaries in PATH" (echo $PATH | string match -q "*/run/current-system/sw/bin*")

# Test Fish completions
@test "Fish completions directory exists" (test -d ~/.config/fish/completions; or test -d /etc/profiles/per-user/$USER/share/fish/vendor_completions.d)

# Test Fish variables
@test "USER variable is set" (test -n "$USER")
@test "HOME variable is set" (test -n "$HOME")
@test "SHELL variable contains fish" (echo $SHELL | string match -q "*fish*")

# Test lsd configuration files exist
@test "lsd config file exists" (test -f ~/.config/lsd/config.yaml)
@test "lsd colors file exists" (test -f ~/.config/lsd/colors.yaml)
@test "lsd config uses custom theme" (grep -q "theme: custom" ~/.config/lsd/config.yaml)
@test "lsd uses Catppuccin Macchiato colors" (grep -q "#c6a0f6" ~/.config/lsd/colors.yaml)

# Test Fish Catppuccin theme
@test "Fish theme file exists" (test -f ~/.config/fish/themes/Catppuccin\ Macchiato.theme)
@test "Catppuccin theme plugin available" (fish -c "functions -q catppuccin_macchiato"; or test -d ~/.config/fish/themes/)