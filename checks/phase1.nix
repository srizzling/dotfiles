{ config, pkgs, lib, ... }:

{
  # Phase 1 completion tests
  phase1-tests = pkgs.runCommand "phase1-tests" {
    buildInputs = with pkgs; [ git fish nodejs ];
  } ''
    # Test 1: Essential packages available
    echo "Testing essential packages..."
    which yamllint || { echo "yamllint not found"; exit 1; }
    which jsonlint || { echo "jsonlint not found"; exit 1; }
    which shellcheck || { echo "shellcheck not found"; exit 1; }
    which gh || { echo "gh not found"; exit 1; }
    which fish || { echo "fish not found"; exit 1; }
    which zoxide || { echo "zoxide not found"; exit 1; }
    echo "✅ All essential packages found"

    # Test 2: Git configuration exists
    echo "Testing git configuration..."
    git config --global user.name | grep -v "^$" || { echo "Git user.name not set"; exit 1; }
    git config --global user.email | grep -v "^$" || { echo "Git user.email not set"; exit 1; }
    echo "✅ Git identity configured"

    # Test 3: Node.js available for claude-code
    echo "Testing Node.js availability..."
    which node || { echo "Node.js not found"; exit 1; }
    which npm || { echo "npm not found"; exit 1; }
    echo "✅ Node.js environment ready"

    # Test 4: Fish shell functional
    echo "Testing fish shell..."
    fish -c "echo 'Fish shell working'" || { echo "Fish shell not working"; exit 1; }
    echo "✅ Fish shell functional"

    echo "🎉 Phase 1 tests passed!"
    touch $out
  '';
}