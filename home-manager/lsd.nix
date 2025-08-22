{ config, pkgs, ... }:

{
  # Configure lsd via config file
  home.file.".config/lsd/config.yaml".text = ''
    # Display
    classic: false
    blocks:
      - permission
      - user
      - group
      - size
      - date
      - name
    color:
      when: auto
      theme: custom
    date: date
    dereference: false
    display: all
    icons:
      when: auto
      theme: fancy
      separator: " "
    ignore-globs: []
    indicators: false
    layout: grid
    recursion:
      enabled: false
      depth: 1
    size: short
    permission: rwx
    sorting:
      column: name
      reverse: false
      dir-grouping: first
    no-symlink: false
    total-size: false
    hyperlink: never
  '';

  # Add Rose Pine theme for lsd
  home.file.".config/lsd/colors.yaml".text = ''
    # Rose Pine color theme for lsd
    # Based on Rose Pine color palette
    
    user: 
      foreground: "#c4a7e7"  # iris
    group:
      foreground: "#ebbcba"  # rose
    
    permission:
      read:
        foreground: "#31748f"  # pine
      write:
        foreground: "#f6c177"  # gold
      exec:
        foreground: "#eb6f92"  # love
      exec-sticky:
        foreground: "#eb6f92"
      no-access:
        foreground: "#6e6a86"  # muted
      octal:
        foreground: "#908caa"  # subtle
      acl:
        foreground: "#9ccfd8"  # foam
      context:
        foreground: "#908caa"  # subtle
    
    date:
      hour-old:
        foreground: "#9ccfd8"  # foam
      day-old:
        foreground: "#31748f"  # pine
      older:
        foreground: "#6e6a86"  # muted
    
    size:
      none:
        foreground: "#908caa"  # subtle
      small:
        foreground: "#31748f"  # pine
      medium:
        foreground: "#f6c177"  # gold
      large:
        foreground: "#eb6f92"  # love
    
    inode:
      foreground: "#6e6a86"  # muted
    
    links:
      foreground: "#9ccfd8"  # foam
    
    tree-edge:
      foreground: "#6e6a86"  # muted
    
    git-status:
      default:
        foreground: "#908caa"  # subtle
      unmodified:
        foreground: "#31748f"  # pine
      ignored:
        foreground: "#6e6a86"  # muted
      new-in-index:
        foreground: "#9ccfd8"  # foam
      new-in-workdir:
        foreground: "#31748f"  # pine
      typechange:
        foreground: "#f6c177"  # gold
      deleted:
        foreground: "#eb6f92"  # love
      renamed:
        foreground: "#c4a7e7"  # iris
      modified:
        foreground: "#f6c177"  # gold
      conflicted:
        foreground: "#eb6f92"  # love
    
    file-type:
      file:
        foreground: "#e0def4"  # text
      directory:
        foreground: "#9ccfd8"  # foam
      symlink:
        foreground: "#ebbcba"  # rose
      pipe:
        foreground: "#c4a7e7"  # iris
      block-device:
        foreground: "#f6c177"  # gold
      char-device:
        foreground: "#f6c177"  # gold
      socket:
        foreground: "#eb6f92"  # love
      special:
        foreground: "#c4a7e7"  # iris
      executable:
        foreground: "#31748f"  # pine
  '';
}