{
  config,
  pkgs,
  ...
}: let
  obsidianPath = "/Users/manuel/Library/Mobile\\ Documents/iCloud~md~obsidian/Documents/Notes";
in {
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    # ===== Development & Programming =====
    cargo # Rust package manager
    go # Go programming language
    jdk17 # Java Development Kit
    maven # Java project management
    nodejs_23 # JavaScript runtime (required for some LSPs)
    nixd # Nix Language Server
    python312 # Python interpreter
    python312Packages.pip # Python package manager
    sqlite # Embedded database
    tree-sitter # Parser generator toolkit
    virtualenv # Python environment isolation

    # ===== DevOps & Automation =====
    ansible # Configuration management
    docker # Containerization platform

    # ===== CLI Productivity & Tools =====
    bat # Modern cat with syntax highlighting
    eza # Modern ls replacement
    fzf # Fuzzy finder
    lazygit # Terminal UI for git
    mcfly # Intelligent command history
    ripgrep # Ultra-fast grep
    starship # Customizable shell prompt
    tmux # Terminal multiplexer
    tokei # Code statistics
    tree # Directory structure viewer
    zoxide # Smart directory navigation

    # ===== System Monitoring =====
    btop # Resource monitor
    dust # Disk usage analyzer
    htop # Process viewer

    # ===== File Management =====
    ranger # Terminal file manager
    xz # Compression utilities

    # ===== Text/Data Processing =====
    jq # JSON processor
    neovim # Modern Vim fork (with plugins)

    # ===== Security =====
    gnupg # Encryption toolkit

    # ===== Networking =====
    arp-scan # ARP packet scanner
    nmap # Network exploration
    wget # File downloader

    # ===== Documentation & Publishing =====
    (texlive.combine {
      # LaTeX typesetting
      inherit
        (texlive)
        scheme-basic
        latexmk
        collection-latex
        titlesec
        ;
    })

    # ===== Nix Ecosystem =====
    alejandra # Nix formatter

    # ===== Commented/Notes =====
  ];
  programs.git = {
    enable = true;
    userName = "Manuel Kuchelmeister";
    userEmail = "makuche-github@pm.me";
    signing = {
      key = "D5E39A037F4AAE1C";
      signByDefault = true;
    };
    extraConfig = {
      commit.gpgsign = true;
      tag.gpgsign = true;
      diff = {
        algorithm = "histogram";
      };
      branch = {
        sort = "committerdate";
      };
      merge = {
        conflictstyle = "zdiff3";
      };
      log = {
        date = "iso";
      };
    };
  };
  programs.lazygit = {
    enable = true;
    settings = {
      customCommands = [
        {
          key = "<c-v>";
          context = "global";
          description = "Create new conventional commit";
          prompts = [
            {
              type = "menu";
              key = "Type";
              title = "Type of change";
              options = [
                {
                  name = "build";
                  description = "Changes that affect the build system or external dependencies";
                  value = "build";
                }
                {
                  name = "feat";
                  description = "A new feature";
                  value = "feat";
                }
                {
                  name = "fix";
                  description = "A bug fix";
                  value = "fix";
                }
                {
                  name = "chore";
                  description = "Other changes that don't modify src or test files";
                  value = "chore";
                }
                {
                  name = "ci";
                  description = "Changes to CI configuration files and scripts";
                  value = "ci";
                }
                {
                  name = "docs";
                  description = "Documentation only changes";
                  value = "docs";
                }
                {
                  name = "perf";
                  description = "A code change that improves performance";
                  value = "perf";
                }
                {
                  name = "refactor";
                  description = "A code change that neither fixes a bug nor adds a feature";
                  value = "refactor";
                }
                {
                  name = "revert";
                  description = "Reverts a previous commit";
                  value = "revert";
                }
                {
                  name = "style";
                  description = "Changes that do not affect the meaning of the code";
                  value = "style";
                }
                {
                  name = "test";
                  description = "Adding missing tests or correcting existing tests";
                  value = "test";
                }
              ];
            }
            {
              type = "input";
              title = "Scope";
              key = "Scope";
              initialValue = "";
            }
            {
              type = "menu";
              key = "Breaking";
              title = "Breaking change";
              options = [
                {
                  name = "no";
                  value = "";
                }
                {
                  name = "yes";
                  value = "!";
                }
              ];
            }
            {
              type = "input";
              title = "message";
              key = "Message";
              initialValue = "";
            }
            {
              type = "confirm";
              key = "Confirm";
              title = "Commit";
              body = "Are you sure you want to commit?";
            }
          ];
          command = "git commit --message '{{.Form.Type}}{{ if .Form.Scope }}({{ .Form.Scope }}){{ end }}{{.Form.Breaking}}: {{.Form.Message}}'";
          loadingText = "Creating conventional commit...";
        }
      ];
    };
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
      ll = "eza -lahF";
      vim = "nvim";
      note = "cd ${obsidianPath} && nvim /${obsidianPath}";
      todo = "nvim /${obsidianPath}/todo.md";
      tm = "tmux";
      tma = "tmux attach";
      tmd = "tmux detach";
      lg = "lazygit";
      htop = "btop";
      rebuild = "darwin-rebuild switch --flake ~/.config/nix-darwin --show-trace --impure";
      cd = "z";
    };
    history = {
      size = 50000;
      save = 50000;
      path = "$HOME/.zsh_history";
      extended = true;
      ignoreDups = true;
      share = true;
      expireDuplicatesFirst = true;
      ignoreSpace = true;
      ignorePatterns = ["rm *" "pkill *" "kill *" "history"];
    };
    initExtra = ''
      eval "$(zoxide init zsh)"
      eval "$(mcfly init zsh)"
      export PATH="/Applications/Ghostty.app/Contents/MacOS:$PATH"
      export MCFLY_FUZZY=true
      export MCFLY_RESULTS=50
      export MCFLY_INTERFACE_VIEW=BOTTOM
      export MCFLY_DISABLE_WELCOME=true
      bindkey '^R' mcfly-history-widget
      export MCFLY_KEY_SCHEME=vim
      setopt EXTENDED_HISTORY
      setopt HIST_EXPIRE_DUPS_FIRST
      setopt HIST_FIND_NO_DUPS
      setopt HIST_REDUCE_BLANKS
      setopt HIST_VERIFY
      setopt APPEND_HISTORY
      setopt INC_APPEND_HISTORY
    '';
  };
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile "${config.home.homeDirectory}/.config/dotfiles/tmux.conf";
  };
}
