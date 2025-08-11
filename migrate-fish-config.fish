#!/usr/bin/env fish
#
# Fish configuration migration helper
# Converts Fisher plugins and custom configurations to Home Manager format
#

set -l YELLOW (set_color yellow)
set -l GREEN (set_color green)
set -l BLUE (set_color blue)
set -l RED (set_color red)
set -l NORMAL (set_color normal)

echo "Fish Configuration Migration Helper"
echo "==================================="
echo ""

# Function to convert Fisher plugin to Nix format
function fisher_to_nix
    set -l plugin $argv[1]
    set -l owner (string split "/" $plugin)[1]
    set -l repo (string split "/" $plugin)[2]
    
    echo "Fetching information for $plugin..."
    
    # Get the latest commit
    set -l commit (git ls-remote "https://github.com/$plugin" HEAD | cut -f1)
    if test -z "$commit"
        echo "$RED  Failed to fetch commit for $plugin$NORMAL"
        return 1
    end
    
    echo "  Latest commit: $commit"
    echo "  Fetching SHA256..."
    
    # Get SHA256
    set -l sha256_output (nix-prefetch-github $owner $repo --rev $commit 2>&1)
    set -l sha256 (echo $sha256_output | grep -o 'sha256 = "[^"]*"' | cut -d'"' -f2)
    
    if test -z "$sha256"
        echo "$RED  Failed to fetch SHA256 for $plugin$NORMAL"
        return 1
    end
    
    # Generate Nix configuration
    echo ""
    echo "$GREEN  Generated Nix configuration:$NORMAL"
    echo "  {"
    echo "    name = \"$repo\";"
    echo "    src = pkgs.fetchFromGitHub {"
    echo "      owner = \"$owner\";"
    echo "      repo = \"$repo\";"
    echo "      rev = \"$commit\";"
    echo "      sha256 = \"$sha256\";"
    echo "    };"
    echo "  }"
    echo ""
end

# Check for Fisher plugins
if command -v fisher &>/dev/null
    echo "$BLUE""Detected Fisher plugins:$NORMAL"
    set -l plugins (fisher list 2>/dev/null)
    
    if test (count $plugins) -gt 0
        echo ""
        echo "Converting Fisher plugins to Nix format..."
        echo "Add these to the 'plugins' section in home-manager/shell.nix:"
        echo ""
        
        for plugin in $plugins
            fisher_to_nix $plugin
        end
    else
        echo "No Fisher plugins found"
    end
else
    echo "$YELLOW""Fisher not installed - skipping plugin migration$NORMAL"
end

# Check for custom functions
echo ""
echo "$BLUE""Checking for custom Fish functions:$NORMAL"

set -l fish_functions_dir "$HOME/.config/fish/functions"
if test -d $fish_functions_dir
    set -l custom_functions (ls $fish_functions_dir/*.fish 2>/dev/null | grep -v "fish_prompt.fish" | grep -v "fish_right_prompt.fish")
    
    if test (count $custom_functions) -gt 0
        echo "Found "(count $custom_functions)" custom functions:"
        echo ""
        echo "Add these to the 'functions' section in home-manager/shell.nix:"
        echo ""
        
        for func_file in $custom_functions
            set -l func_name (basename $func_file .fish)
            echo "$GREEN$func_name = ''$NORMAL"
            cat $func_file | sed 's/^/  /'
            echo "$GREEN'';$NORMAL"
            echo ""
        end
    else
        echo "No custom functions found"
    end
else
    echo "Fish functions directory not found"
end

# Check for custom aliases
echo ""
echo "$BLUE""Checking for custom aliases:$NORMAL"

# Source the config to get aliases
set -l temp_file (mktemp)
fish -c 'alias' > $temp_file 2>/dev/null

if test -s $temp_file
    echo "Found aliases - add these to 'shellAliases' in home-manager/shell.nix:"
    echo ""
    
    cat $temp_file | while read line
        # Parse alias format: alias name='command'
        if string match -q "alias *" $line
            set -l parts (string split "=" $line)
            set -l name (string replace "alias " "" $parts[1] | string trim)
            set -l command (string join "=" $parts[2..-1] | string trim -c "'\"")
            echo "  $name = \"$command\";"
        end
    end
else
    echo "No aliases found"
end
rm -f $temp_file

# Check for environment variables
echo ""
echo "$BLUE""Checking for custom environment variables:$NORMAL"

if test -f "$HOME/.config/fish/config.fish"
    set -l env_vars (grep -E "^set -[gx]+ " "$HOME/.config/fish/config.fish" | grep -v "fish_" | grep -v "PATH")
    
    if test (count $env_vars) -gt 0
        echo "Found environment variables - add these to home.sessionVariables in home-manager/default.nix:"
        echo ""
        
        for var in $env_vars
            echo "  $var"
        end
    else
        echo "No custom environment variables found"
    end
end

# Check for custom key bindings
echo ""
echo "$BLUE""Checking for custom key bindings:$NORMAL"

if functions -q fish_user_key_bindings
    echo "Found fish_user_key_bindings function"
    echo "Add key bindings to interactiveShellInit in home-manager/shell.nix"
    echo ""
    functions fish_user_key_bindings
end

# Summary
echo ""
echo "======================================="
echo "$GREEN""Migration Summary$NORMAL"
echo "======================================="
echo ""
echo "1. Copy the generated plugin configurations to home-manager/shell.nix"
echo "2. Add custom functions to the 'functions' section"
echo "3. Add aliases to the 'shellAliases' section"
echo "4. Add environment variables to home-manager/default.nix"
echo "5. Run 'make switch' to apply changes"
echo ""
echo "Remember to test your configuration after migration!"