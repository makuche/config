{
  config,
  pkgs,
  lib,
  nixpkgs-terraform,
  ...
}: let
  pkgs-terraform = import nixpkgs-terraform {system = pkgs.stdenv.hostPlatform.system; config.allowUnfree = true;};
  tmux-sessionizer = pkgs.writeShellScriptBin "tmux-sessionizer" (builtins.readFile ../../assets/tmux-sessionizer);
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
    btop # Resource manager
    bun # For JavaScript projects
    cargo # Rust package manager
    go # Go programming language

    # LaTeX - Document preparation system
    (texlive.combine {
      inherit
        (texlive)
        scheme-basic
        latexmk
        collection-latex
        collection-latexextra
        collection-fontsrecommended
        titlesec
        fontawesome5
        ;
    })

    # .NET SDK - multiple versions for different projects
    (with dotnetCorePackages;
      combinePackages [
        sdk_10_0 # .NET 10.0.102
        sdk_9_0 # .NET 9.0.310
        sdk_8_0 # .NET 8.0.417
      ])

    lua
    luarocks
    httpie # CLI http client
    hyperfine # benchmarking tool, use via hyperfine "COMMAND"
    imhex # hex viewer
    jdk17 # Java Development Kit
    gh # GitHub CLI
    gh-dash # TODO: not sure if this adds any value... GH PR in browser works better
    kubectl
    lua-language-server
    kompose # translate docker-compose to manifests
    maven # Java project management
    nodejs_24 # JavaScript runtime (for LSPs)
    nixd # Nix Language Server
    nushell # nice for formatted outputs
    python312 # Python interpreter
    python312Packages.pip # Python package manager
    python312Packages.ipython # Better interpreter
    sqlite # Embedded database
    tracy # profiler
    pkgs-terraform.terraform # infrastructure (pinned: nix flake update nixpkgs-terraform)
    tree-sitter # Parser generator toolkit
    uv # Python package manager
    virtualenv # Python environment isolation
    yarn

    # ===== CLI Tools =====
    bat # Modern cat with syntax highlighting
    delta # nicer diff tool
    dua # Interactive disk usage analyzer, use via `dua i` for interactive use
    dust
    diff-so-fancy
    eza # Modern ls replacement
    fd # find alternative
    fzf # Fuzzy finder
    # lazydocker
    mcfly # Intelligent command history
    mpv
    ripgrep # Ultra-fast grep
    ripgrep-all # ripgrep for pdfs etc.
    tmux # Terminal multiplexer
    tokei # Code statistics
    tree # Directory structure viewer
    xh # http tool
    wiki-tui # wikipedia in text interface
    zoxide # Smart directory navigation

    # ===== File Management =====
    # ffmpeg # stream audio and video
    # p7zip # unzip z7 files
    # pdftk # Process PDFs
    # ranger # Terminal file manager
    # rclone # cloud file sync
    # xz # Compression utilities

    # ===== Text Processing =====
    jq # JSON processor
    yq # yaml processor
    # neovim # Modern Vim fork (with plugins)

    # ===== Security =====
    # clamav # Additional utilities
    gnupg # Encryption toolkit
    git-crypt # Encrypt files in git repo
    trufflehog # Detect token leakage

    # ===== Networking =====
    arp-scan # ARP packet scanner
    nmap # Network exploration
    wget # File downloader

    # Custom Scripts
    tmux-sessionizer
  ];

  home.file.".local/share/gh/extensions/gh-dash/gh-dash" = {
    source = "${gh-dash}/bin/gh-dash";
    executable = true;
  };

  home.file.".aerospace.toml".source = ../../assets/aerospace.toml;
  home.file.".config/btop/btop.conf".source = ../../assets/btop.conf;
  home.file.".config/tmux/tmux.conf".source = ../../assets/tmux.conf;
  home.file.".config/ghostty/config".source = ../../ghostty/config;
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/git/config/nvim";

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # common program configurations
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    signing = {
      signByDefault = true;
    };
    settings = {
      user = {
        name = "Manuel Kuchelmeister";
        email = "makuche-github@pm.me";
      };
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
        longpaths = true;
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
      pager = {
        diff = "delta";
        log = "delta";
        reflog = "delta";
        show = "delta";
      };
      interactive = {
        diffFilter = "delta --color-only --features=interactive";
      };
      delta = {
        line-numbers = true;
        side-by-side = true;
        navigate = true;
        light = false;
      };
      alias = {
        # Delta diffs
        d = "diff";
        ds = "diff --staged";
        dc = "diff --cached";
        dh = "diff HEAD";

        # Branch/commit comparisons
        compare = "diff";

        # File history with diffs
        file-history = "log --follow -p --";

        # Useful shortcuts
        tree = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        files = "diff --name-only";
        stat = "diff --stat";
      };
    };
  };
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        pagers = [
          {
            cmd = "delta --color-only --dark --paging=never";
            type = "diff";
          }
        ];
        pull = {
          mode = "merge";
        };
        autoFetch = true;
        fetchAll = true;
      };
      customCommands = [
        {
          key = "t";
          context = "global";
          description = "Force fetch all tags";
          command = "git fetch --tags --force";
          loadingText = "Fetching tags...";
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
    initContent = lib.mkMerge [
      # Must run before compinit (order 550)
      (lib.mkOrder 550 ''
        ZSH_DISABLE_COMPFIX=true
      '')
      # Regular init content (runs after compinit)
      ''
        eval "$(zoxide init zsh)"
        eval "$(mcfly init zsh)"
        export PATH="/run/current-system/sw/bin:$PATH" # required to use Nix Determinate System Installer
        export PATH="/Users/manuel/.bun/bin:$PATH" # enable usage of bun installed packages
        export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
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

        # re-attach or start tmux session on new shell
        if [[ -z "$TMUX" ]]; then
          tmux attach -t main 2>/dev/null || tmux new -s main
        fi
      ''
    ];

    shellAliases = {
      ls = "eza";
      l = "eza -lahF";
      vim = "nvim";
      nvim-dev = "'NVIM_APPNAME=nvim-dev nvim'";
      lg = "lazygit";
      htop = "btop";
      ports = "lsof -iTCP -sTCP:LISTEN -n -P";
      cd = "z";
      y = "yazi";
      claude = "/Users/manuel/.claude/local/claude";
      ghostty = "/Applications/Ghostty.app/Contents/MacOS/ghostty";
      chat = "open -na 'Brave Browser' --args --app='https://claude.ai'";
      mail = "open -na 'Brave Browser' --args --app='https://mail.proton.me'";
      draw = "open -na 'Brave Browser' --args --app='https://app.diagrams.net'";
      cpall = "f(){ o=$(find \"\${1:-.}\" -type f | sort | while read l; do echo \"=== $l ===\"; cat \"$l\"; echo; done); echo \"$o\"|pbcopy; w=$(echo \"$o\"|wc -w|tr -d \" \"); c=$(echo \"$o\"|wc -c|tr -d \" \"); t=$((c/4)); [ $t -ge 1000000 ] && tk=\"$((t/1000))K\" || { [ $t -ge 1000 ] && tk=\"\${t%???}K\" || tk=\"$t\"; }; echo \"Copied. \${w} words, ~\${tk} tokens\"; }; f";
      rain = "open -na 'Brave Browser' --args --app='https://www.meteoswiss.admin.ch/services-and-publications/applications/precipitation.html'";
      stand = "nix run ~/git/idasen-desk#stand";
      sit = "nix run ~/git/idasen-desk#sit";
    };
  };

  programs.k9s = {
    enable = true;
    settings = {
      k9s = {
        ui = {
          crumbsless = true;
          enableMouse = false;
          headless = true;
          logoless = true;
          noIcons = false;
        };
        maxConnRetry = 5;
        noExitOnCtrlC = true;
        readOnly = false;
        refreshRate = 2; # default 2sec
        skipLatestRevCheck = false;
        logger = {
          buffer = 5000;
          fullScreenLogs = false;
          showTime = false;
          sinceSeconds = 60;
          tail = 100;
          textWrap = false;
        };
        thresholds = {
          cpu = {
            critical = 90;
            warn = 75;
          };
          memory = {
            critical = 90;
            warn = 75;
          };
        };
        body.bgColor = "default";
      };
    };
  };

  programs.yazi = {
    enable = true;
    plugins = {
      git = pkgs.yaziPlugins.git;
    };
    initLua = ''
      require("git"):setup()
    '';
    settings = {
      mgr = {
        ratio = [ 1 2 5 ];
        sort_by = "natural";
        linemode = "size";
      };
    };
  };

  programs.keychain = {
    enable = true;
    enableZshIntegration = true;
    keys = ["id_ed25519"];
  };
}
