{pkgs, ...}: let
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
  obsidianPath = "/Users/manuel/Library/Mobile\\ Documents/iCloud~md~obsidian/Documents/Notes";
in {
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    alejandra
    bat
    btop
    dust
    eza
    fzf
    jq
    mcfly
    ranger
    ripgrep
    tree
    starship
    tmux
    zoxide

    tree-sitter
    nixd
    nodejs_23 # required to install LSPs
    cargo
    go
    unstable.neovim # unstable due to plugin usage
    htop
    lazygit
  ];

  programs.git = {
    enable = true;
    userName = "Manuel Kuchelmeister";
    userEmail = "manuel.kuchelmeister@web.de";
  };
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      command_timeout = 1300;
      scan_timeout = 50;
      format = "$all$nix_shell$nodejs$lua$golang$rust$php$git_branch$git_commit$git_state$git_status\n$username$hostname$directory";
      character = {
        success_symbol = "[](bold green) ";
        error_symbol = "[✗](bold red) ";
      };
    };
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ls = "eza";
      ll = "ls -lahF";
      vim = "nvim";
      note = "cd ${obsidianPath} && nvim /${obsidianPath}";
      tm = "tmux";
      tma = "tmux attach";
      tmd = "tmux detach";
      lg = "lazygit";
      htop = "btop";
      rebuild = "darwin-rebuild switch --flake ~/.config/nix-darwin --show-trace --impure";
      cd = "z";
    };
    initExtra = ''
      eval "$(zoxide init zsh)"
    '';
  };
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ~/.config/dotfiles/tmux.conf;
  };
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };
      window = {
        padding = {
          x = 10;
          y = 10;
        };
        opacity = 0.9;
        blur = true;
        option_as_alt = "Both";
        decorations = "Buttonless";
      };
      font = {
        normal = {
          family = "Mononoki Nerd Font";
        };
        size = 15;
      };
      colors = {
        primary = {
          background = "#2e3440";
          foreground = "#d8dee9";
          dim_foreground = "#a5abb6";
        };
        cursor = {
          text = "#2e3440";
          cursor = "#d8dee9";
        };
        vi_mode_cursor = {
          text = "#2e3440";
          cursor = "#d8dee9";
        };
        selection = {
          text = "CellForeground";
          background = "#4c566a";
        };
        search = {
          matches = {
            foreground = "CellBackground";
            background = "#88c0d0";
          };
        };
        normal = {
          black = "#3b4252";
          red = "#bf616a";
          green = "#a3be8c";
          yellow = "#ebcb8b";
          blue = "#81a1c1";
          magenta = "#b48ead";
          cyan = "#88c0d0";
          white = "#e5e9f0";
        };
        bright = {
          black = "#4c566a";
          red = "#bf616a";
          green = "#a3be8c";
          yellow = "#ebcb8b";
          blue = "#81a1c1";
          magenta = "#b48ead";
          cyan = "#8fbcbb";
          white = "#eceff4";
        };
        dim = {
          black = "#373e4d";
          red = "#94545d";
          green = "#809575";
          yellow = "#b29e75";
          blue = "#68809a";
          magenta = "#8c738c";
          cyan = "#6d96a5";
          white = "#aeb3bb";
        };
      };
    };
  };
}
