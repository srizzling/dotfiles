{ config, pkgs, lib, ... }:

{
  # Enable Catppuccin theming for tools without rose-pine themes
  catppuccin = {
    enable = true;
    # Upstream is moving to autoEnable for port enrollment, with enable becoming
    # a global kill switch. Setting it explicitly keeps today's behaviour and
    # silences the migration warning. Per-port opt-outs below still apply.
    autoEnable = true;
    flavor = "macchiato";

    # Disable for tools that have rose-pine themes configured
    bat.enable = true;          # Keep catppuccin for bat (rose-pine setup is complex)
    delta.enable = false;       # Using custom rose-pine configuration
    fzf.enable = false;         # Using official rose-pine theme
    starship.enable = false;    # Using official rose-pine preset
    fish.enable = false;        # Using rose-pine-fish plugin

    # Enable for tools that don't have rose-pine alternatives
    firefox.enable = true;
    vscode.profiles.default.enable = false;  # User manages vscode themes manually
    spotify-player.enable = true;
  };
}