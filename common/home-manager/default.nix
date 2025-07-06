{
  config,
  pkgs,
  lib,
  ...
}: let
  homeDirectory = config.home.homeDirectory;
  secretsDir = "${homeDirectory}/.config/git-secrets";
  gh-dash = pkgs.buildGoModule rec {
    pname = "gh-dash";
    version = "4.7.3";

    src = pkgs.fetchFromGitHub {
      owner = "dlvhdr";
      repo = "gh-dash";
      rev = "v${version}";
      hash = "sha256-QDqGsVgY3Je1VgQVobDhNkVjrCyvMNEdghXc0ny+yyo=";
    };

    vendorHash = "sha256-lqmz+6Cr9U5IBoJ5OeSN6HKY/nKSAmszfvifzbxG7NE=";
  };
in {
  home.stateVersion = "24.05";

  # common packages across all hosts
  home.packages = with pkgs; [
    # ===== Development =====
    alejandra # Nix formatter
    bun # For JavaScript projects
    cargo # Rust package manager
    colima
    docker # Add MacBook-specific packages
    docker-compose
    go # Go programming language
    hexyl # Hex viewer
    httpie # CLI http client
    hyperfine # benchmarking tool, use via hyperfine "COMMAND"
    imhex # hex viewer
    jdk17 # Java Development Kit
    gh # GitHub CLI
    k9s # Cluster dashboard
    kompose # translate docker-compose to manifests
    maven # Java project management
    nodejs_24 # JavaScript runtime (for LSPs)
    nixd # Nix Language Server
    python312 # Python interpreter
    python312Packages.pip # Python package manager
    sqlite # Embedded database
    tracy # profiler
    terraform # infrastructure
    tree-sitter # Parser generator toolkit
    uv # Python package manager
    virtualenv # Python environment isolation

    # ===== CLI Tools =====
    bat # Modern cat with syntax highlighting
    delta # nicer diff tool
    dua # Interactive disk usage analyzer, use via `dua i` for interactive use
    dust
    direnv # Manage envs automatically
    diff-so-fancy
    eza # Modern ls replacement
    fd # find alternative
    fzf # Fuzzy finder
    lazygit # Terminal UI for git
    lazydocker
    mcfly # Intelligent command history
    ncspot # spotify cli
    ripgrep # Ultra-fast grep
    ripgrep-all # ripgrep for pdfs etc.
    starship # Customizable shell prompt
    tmux # Terminal multiplexer
    tokei # Code statistics
    tree # Directory structure viewer
    xh # http tool
    wiki-tui # wikipedia in text interface
    yazi # like ranger but with image rendering
    zoxide # Smart directory navigation

    # ===== File Management =====
    ffmpeg # stream audio and video
    p7zip # unzip z7 files
    pdftk # Process PDFs
    ranger # Terminal file manager
    xz # Compression utilities
    zathura # Document viewers

    # ===== Text Processing =====
    jq # JSON processor
    yq # yaml processor
    neovim # Modern Vim fork (with plugins)

    # ===== Security =====
    # clamav # Additional utilities
    keychain # Enables long-running ssh-agent
    gnupg # Encryption toolkit
    git-crypt # Encrypt files in git repo
    trufflehog # Detect token leakage

    # ===== Networking =====
    arp-scan # ARP packet scanner
    nmap # Network exploration
    wget # File downloader
  ];

  home.file.".local/share/gh/extensions/gh-dash/gh-dash" = {
    source = "${gh-dash}/bin/gh-dash";
    executable = true;
  };

  # common program configurations
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    extraConfig = {
      column = {
        ui = "auto";
      };
      branch = {
        sort = "-committerdate";
      };
      tag = {
        gpgsign = true;
        sort = "version:refname";
      };
      init = {
        defaultBranch = "main";
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      help = {
        autocorrect = "prompt";
      };
      commit = {
        gpgsign = true;
        verbose = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      core = {
        excludesfile = "~/.gitignore"; #TODO: Add this to the config repo
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      merge = {
        conflictstyle = "zdiff3";
      };
      log = {
        date = "iso";
      };
      pull = {
      };
      include = {
        path = "${secretsDir}/gitconfig.default";
      };
      # Every subfolder under dap/ will get overwritten git config params
      "includeIf \"gitdir:~/git/dap/\"" = {
        path = "${secretsDir}/gitconfig.dap";
      };
    };
  };
  programs.lazygit = {
    enable = true;
    settings = {
      customCommands = [
        {
          key = "<c-v>";
          context = "files";
          description = "Commit using convention";
          prompts = [
            {
              type = "menu";
              key = "Type";
              title = "Type of change";
              options = [
                {
                  name = "[Core] feat";
                  description = "A new feature for the user";
                  value = "feat";
                }
                {
                  name = "[Core] fix";
                  description = "A bug fix";
                  value = "fix";
                }
                {
                  name = "[Core] docs";
                  description = "Documentation changes";
                  value = "docs";
                }
                {
                  name = "[Core] style";
                  description = "Changes that don't affect code meaning (formatting, whitespace)";
                  value = "style";
                }
                {
                  name = "[Core] refactor";
                  description = "Code changes that neither fix a bug nor add a feature";
                  value = "refactor";
                }
                {
                  name = "[Core] perf";
                  description = "Performance improvements";
                  value = "perf";
                }
                {
                  name = "[Core] test";
                  description = "Adding or correcting tests";
                  value = "test";
                }
                {
                  name = "[Core] build";
                  description = "Changes affecting build system or dependencies";
                  value = "build";
                }
                {
                  name = "[Core] chore";
                  description = "Routine maintenance tasks, dependency updates, configs";
                  value = "chore";
                }
                # Content
                {
                  name = "[Content] content";
                  description = "Changes to website or app content, copy, or text";
                  value = "content";
                }
                # Knowledge Management
                {
                  name = "[Doc] note";
                  description = "Personal notes or documentation";
                  value = "note";
                }
                {
                  name = "[Doc] wiki";
                  description = "Wiki page or knowledge base changes";
                  value = "wiki";
                }
                # Data & Schema
                {
                  name = "[Data] data";
                  description = "Dataset or data asset updates";
                  value = "data";
                }
                {
                  name = "[Data] schema";
                  description = "Data structure or schema changes";
                  value = "schema";
                }
                # Design & UI
                {
                  name = "[UI] design";
                  description = "Design or UX changes";
                  value = "design";
                }
                {
                  name = "[UI] ui";
                  description = "User interface component changes";
                  value = "ui";
                }
                # Infrastructure & Configuration
                {
                  name = "[Infra] config";
                  description = "Configuration file changes";
                  value = "config";
                }
                {
                  name = "[Infra] env";
                  description = "Environment settings and variables";
                  value = "env";
                }
                {
                  name = "[Infra] deploy";
                  description = "Deployment scripts or configurations";
                  value = "deploy";
                }
                {
                  name = "[Infra] infra";
                  description = "Infrastructure changes";
                  value = "infra";
                }
                {
                  name = "[Infra] script";
                  description = "Utility or automation scripts";
                  value = "script";
                }
                {
                  name = "[Infra] ci";
                  description = "Changes to CI configuration files and scripts";
                  value = "ci";
                }
                # Version Control & Releases
                {
                  name = "[Version Control] sync";
                  description = "Synchronization with upstream or branches";
                  value = "sync";
                }
                {
                  name = "[Version Control] patch";
                  description = "Small updates to existing features";
                  value = "patch";
                }
                {
                  name = "[Version Control] release";
                  description = "Release preparation";
                  value = "release";
                }
                {
                  name = "[Version Control] revert";
                  description = "Reverts a previous commit";
                  value = "revert";
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
        success_symbol = "[](bold green) ";
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

    # Common shell history settings
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

    # Common initialization
    initContent = ''
      eval "$(zoxide init zsh)"
      eval "$(mcfly init zsh)"
      export PATH="${config.home.homeDirectory}/Applications/Ghostty.app/Contents/MacOS:$PATH"
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
      setopt complete_aliases # enable completion for aliases
      ll() { eza -lahF "$@" }
      y() {
      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
      yazi "$@" --cwd-file="$tmp"
      IFS= read -r -d $'\0' cwd < "$tmp"
      [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
      rm -f -- "$tmp"
      }
      setopt INC_APPEND_HISTORY
      export EDITOR=nvim
    '';
  };

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };

  programs.keychain = {
    enable = true;
    enableZshIntegration = true;
    keys = ["id_rsa" "id_ed25519"];
  };
}
