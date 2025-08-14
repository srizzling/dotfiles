{ config, pkgs, profile, ... }:

{
  # Fish shell configuration
  programs.fish = {
    enable = true;
    
    # Set PATH early before aliases are loaded (for both login and non-login shells)
    shellInit = ''
      # Add Nix system-wide packages to PATH
      fish_add_path --prepend /run/current-system/sw/bin
      fish_add_path --prepend /nix/var/nix/profiles/default/bin
      fish_add_path --prepend /etc/profiles/per-user/srizzling/bin
    '';
    
    # Also set PATH for login shells
    loginShellInit = ''
      # Add Nix system-wide packages to PATH
      fish_add_path --prepend /run/current-system/sw/bin
      fish_add_path --prepend /nix/var/nix/profiles/default/bin
      fish_add_path --prepend /etc/profiles/per-user/srizzling/bin
    '';
    
    # Additional interactive shell configuration
    interactiveShellInit = ''
      # Add vendor functions for fzf and other tools
      set -p fish_function_path /etc/profiles/per-user/srizzling/share/fish/vendor_functions.d
      set -p fish_function_path ${pkgs.fzf}/share/fish/vendor_functions.d
      
      # Set Catppuccin Macchiato theme (only if not already set)
      if not test -f ~/.config/fish/themes/current_theme
        fish_config theme save "Catppuccin Macchiato" >/dev/null 2>&1 || true
        echo "Catppuccin Macchiato" > ~/.config/fish/themes/current_theme
      end
      
      # Configure fzf.fish to use delta for diff highlighting
      set -gx fzf_diff_highlighter delta --paging=never --width=20
      
      # Configure fzf key bindings and options
      set -gx FZF_DEFAULT_OPTS '--height 50% --layout=reverse --border --margin=1 --padding=1'
      
      # fzf.fish configuration variables
      set fzf_history_opts --preview-window=wrap --preview='echo {}'
      set fzf_directory_opts --preview='lsd -la --color=always {}'  
      set fzf_git_log_opts --preview='git show --color=always {}'
      set fzf_git_status_opts --preview='git diff --color=always {}'
      set fzf_processes_opts --preview='ps -p {} -o pid,ppid,user,start,time,command'
      
      # Generate completions for tools that support it
      if command -v gh >/dev/null 2>&1
        gh completion --shell fish | source
      end
      
      if command -v just >/dev/null 2>&1
        just --completions fish | source
      end
      
      # Generate one-time completions for tools that support it
      if command -v cocogitto >/dev/null 2>&1 && test ! -f ~/.config/fish/completions/cog.fish
        mkdir -p ~/.config/fish/completions
        cog generate-completions fish > ~/.config/fish/completions/cog.fish 2>/dev/null || true
      end
      
      if command -v spotify_player >/dev/null 2>&1 && test ! -f ~/.config/fish/completions/spotify_player.fish
        mkdir -p ~/.config/fish/completions
        spotify_player generate shell-completion fish > ~/.config/fish/completions/spotify_player.fish 2>/dev/null || true
      end
      
      # Generate Claude CLI completions if not present
      if command -v claude >/dev/null 2>&1 && test ! -f ~/.config/fish/completions/claude.fish
        mkdir -p ~/.config/fish/completions
        printf '%s\n' \
          '# Fish completions for Claude CLI' \
          ' ' \
          '# Main command completions' \
          'complete -c claude -f' \
          ' ' \
          '# Commands' \
          'complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -a "config" -d "Manage configuration"' \
          'complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -a "mcp" -d "Configure and manage MCP servers"' \
          'complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -a "migrate-installer" -d "Migrate from global npm installation to local installation"' \
          'complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -a "setup-token" -d "Set up a long-lived authentication token"' \
          'complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -a "doctor" -d "Check the health of your Claude Code auto-updater"' \
          'complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -a "update" -d "Check for updates and install if available"' \
          'complete -c claude -n "not __fish_seen_subcommand_from config mcp migrate-installer setup-token doctor update install" -a "install" -d "Install Claude Code native build"' \
          ' ' \
          '# Global options' \
          'complete -c claude -s d -l debug -d "Enable debug mode"' \
          'complete -c claude -l verbose -d "Override verbose mode setting from config"' \
          'complete -c claude -s p -l print -d "Print response and exit (useful for pipes)"' \
          'complete -c claude -l output-format -d "Output format (only works with --print)" -x -a "text json stream-json"' \
          'complete -c claude -l input-format -d "Input format (only works with --print)" -x -a "text stream-json"' \
          'complete -c claude -l mcp-debug -d "[DEPRECATED] Enable MCP debug mode"' \
          'complete -c claude -l dangerously-skip-permissions -d "Bypass all permission checks"' \
          'complete -c claude -l allowedTools -d "Comma or space-separated list of tool names to allow" -x' \
          'complete -c claude -l disallowedTools -d "Comma or space-separated list of tool names to deny" -x' \
          'complete -c claude -l mcp-config -d "Load MCP servers from a JSON file or string" -r' \
          'complete -c claude -l append-system-prompt -d "Append a system prompt to the default system prompt" -x' \
          'complete -c claude -l permission-mode -d "Permission mode to use for the session" -x -a "acceptEdits bypassPermissions default plan"' \
          'complete -c claude -s c -l continue -d "Continue the most recent conversation"' \
          'complete -c claude -s r -l resume -d "Resume a conversation" -x' \
          'complete -c claude -l model -d "Model for the current session" -x -a "sonnet opus"' \
          'complete -c claude -l fallback-model -d "Enable automatic fallback to specified model" -x -a "sonnet opus"' \
          'complete -c claude -l settings -d "Path to a settings JSON file" -r' \
          'complete -c claude -l add-dir -d "Additional directories to allow tool access to" -r' \
          'complete -c claude -l ide -d "Automatically connect to IDE on startup"' \
          'complete -c claude -l strict-mcp-config -d "Only use MCP servers from --mcp-config"' \
          'complete -c claude -l session-id -d "Use a specific session ID for the conversation" -x' \
          'complete -c claude -s v -l version -d "Output the version number"' \
          'complete -c claude -s h -l help -d "Display help for command"' \
          ' ' \
          '# Config subcommand completions' \
          'complete -c claude -n "__fish_seen_subcommand_from config" -a "set get list" -d "Config operations"' \
          ' ' \
          '# Install subcommand completions' \
          'complete -c claude -n "__fish_seen_subcommand_from install" -a "stable latest" -d "Installation targets"' \
          > ~/.config/fish/completions/claude.fish
      end
    '';
    
    # Shell aliases
    shellAliases = {
      # Basic aliases
      ls = "lsd";
      ll = "lsd -la";
      la = "lsd -a";
      l = "lsd";
      tree = "lsd --tree";
      
      # Git aliases (basic ones, more complex ones in git config)
      gs = "git status";
      gd = "git diff";
      gl = "git log --oneline";
      
      # Nix/Darwin aliases  
      darwin-switch = "darwin-rebuild switch --flake ~/.dotfiles";
      darwin-rollback = "darwin-rebuild rollback";
      
      # Container aliases for Docker compatibility
      docker = "podman";
      docker-compose = "podman-compose";
    };

    # Fish functions with fzf integrations
    functions = {
      # fzf-enhanced git checkout
      gco = ''
        if git rev-parse --git-dir >/dev/null 2>&1
          set -l branch (git branch --all | grep -v HEAD | sed 's/^[* ] //' | sed 's/remotes\///' | sort -u | fzf --height=20 --reverse --preview='git log --oneline --color=always {}' --preview-window=right:60%)
          if test -n "$branch"
            git checkout (echo $branch | sed 's/origin\///')
          end
        else
          echo "Not in a git repository"
        end
      '';
      
      # fzf-enhanced process killer  
      fkill = ''
        set -l pid (ps -ef | sed 1d | fzf --multi --height=50% --reverse --preview='ps -p {2} -o pid,ppid,user,start,time,command' | awk '{print $2}')
        if test -n "$pid"
          echo $pid | xargs kill -9
          echo "Killed process(es): $pid"
        end
      '';
      
      # fzf-enhanced directory navigation
      fcd = ''
        set -l dir (find . -type d 2>/dev/null | fzf --height=40% --reverse --preview='lsd -la --color=always {}')
        if test -n "$dir"
          cd "$dir"
        end
      '';
      
      # fzf-enhanced file search and edit
      fe = ''
        set -l file (find . -type f 2>/dev/null | fzf --height=50% --reverse --preview='bat --color=always --line-range=:50 {}')
        if test -n "$file"
          $EDITOR "$file"
        end
      '';
      
      # fzf-enhanced git log browser
      gll = ''
        if git rev-parse --git-dir >/dev/null 2>&1
          git log --oneline --color=always | fzf --ansi --height=80% --reverse --preview='git show --color=always {1}' --preview-window=right:60%
        else
          echo "Not in a git repository"
        end
      '';
      
      # fzf-enhanced environment variable browser
      fenv = ''
        env | fzf --height=50% --reverse --preview='echo "Variable: {1}"'
      '';
      
      # fzf-enhanced command history search with execution
      fh = ''
        set -l cmd (history | fzf --height=50% --reverse --preview='echo {}' --query=(commandline -b))
        if test -n "$cmd"
          commandline -rb "$cmd"
        end
      '';
    };

    # Fish plugins via Home Manager (minimal essential plugins only)
    plugins = [
      # Catppuccin theme for Fish
      {
        name = "catppuccin-fish";
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "fish";
          rev = "0ce27b518e8ead555dec34dd8be3df5bd75cff8e";
          sha256 = "sha256-Dc/zdxfzAUM5NX8PxzfljRbYvO9f9syuLO8yBr+R3qg=";
        };
      }
      # fish-git-emojis - Git commit emojis
      {
        name = "fish-git-emojis";
        src = pkgs.fetchFromGitHub {
          owner = "srizzling";
          repo = "fish-git-emojis";
          rev = "bf62bd6e6f77b64f743c94d672ad6f0d8fd6415f";
          sha256 = "sha256-vtgXLb9sCu1FrmLw4mWzHeieBvYw4Xmr3pi0vD8+gdo=";
        };
      }
      # fzf.fish - Better fzf integration (forked version with additional features)
      {
        name = "fzf.fish";
        src = pkgs.fetchFromGitHub {
          owner = "srizzling";
          repo = "fzf.fish";
          rev = "34a0fd73e7244e75049258c75d88f92abbb3d31a";
          sha256 = "sha256-nAyPhCNIpDwR9MVyzU9CbUl/vc+CfSTaTTywIbTeP+Y=";
        };
      }
    ];

    # Catppuccin theme will be set manually via fish_config
    # as it's easier to manage interactively
  };

  # Enable additional program integrations with completions
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Starship prompt - full configuration from dotfiles repo  
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      character = {
        error_symbol = "[λ](red)";
        success_symbol = "[λ](purple)";
      };
      aws = {
        format = " [$symbol($profile )(\\($region\\) )(\\[$duration\\])]($style)";
        style = "242";
        region_aliases = {
          "ap-southeast-2" = "ase2";
          "us-east-1" = "use1";
          "us-west-2" = "usw2";
        };
      };
      azure = {
        disabled = false;
        format = "[$symbol($subscription)]($style) ";
        style = "242";
        symbol = "󰠅 ";
      };
      hostname = {
        style = "242";
      };
      cmake.disabled = true;
      cmd_duration = {
        format = " [$duration]($style)";
        min_time = 500;
      };
      conda.disabled = true;
      crystal.disabled = true;
      dart.disabled = true;
      directory = {
        read_only = " 🔒";
        style = "blue";
        truncate_to_repo = true;
        truncation_length = 0;
      };
      docker_context.disabled = true;
      dotnet.disabled = true;
      elixir.disabled = true;
      elm.disabled = true;
      env_var.disabled = true;
      erlang.disabled = true;
      gcloud.disabled = true;
      git_branch = {
        format = "[$symbol](red)[($branch)]($style)";
        style = "242";
        symbol = "";
      };
      git_status = {
        ahead = "[⇡](cyan)";
        behind = "[⇣](cyan)";
        diverged = "[⇡⇣](cyan)";
        format = "([$modified $ahead_behind]($style))";
        modified = "[*](218)";
        stashed = "[≡](cyan)";
      };
      golang.disabled = true;
      helm.disabled = true;
      java.disabled = true;
      jobs.disabled = true;
      julia.disabled = true;
      kotlin.disabled = true;
      kubernetes.disabled = true;
      lua.disabled = true;
      nim.disabled = true;
      nix_shell.disabled = true;
      nodejs.disabled = true;
      ocaml.disabled = true;
      openstack.disabled = true;
      package.disabled = true;
      perl.disabled = true;
      php.disabled = true;
      purescript.disabled = true;
      python.disabled = true;
      ruby.disabled = true;
      rust.disabled = true;
      scala.disabled = true;
      shlvl.disabled = true;
      singularity.disabled = true;
      swift.disabled = true;
      terraform.disabled = true;
      vagrant.disabled = true;
      zig.disabled = true;
    };
  };
}