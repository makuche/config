{
  config,
  pkgs,
  ...
}: {
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    # ===== Development =====
    alejandra # Nix formatter
    cargo # Rust package manager
    go # Go programming language
    httpie # CLI http client
    jdk17 # Java Development Kit
    maven # Java project management
    nodejs_23 # JavaScript runtime (required for some LSPs)
    nixd # Nix Language Server
    python312 # Python interpreter
    python312Packages.pip # Python package manager
    sqlite # Embedded database
    tree-sitter # Parser generator toolkit
    uv # Python package manager
    virtualenv # Python environment isolation

    # ===== DevOps =====
    ansible # Configuration management
    docker # Containerization platform

    # ===== CLI Tools =====
    bat # Modern cat with syntax highlighting
    direnv # Manage envs automatically
    diff-so-fancy # Use via diff -u file1 fil2 | diff-so-fancy
    eza # Modern ls replacement
    fzf # Fuzzy finder
    lazygit # Terminal UI for git
    mcfly # Intelligent command history
    ripgrep # Ultra-fast grep
    ripgrep-all # ripgrep for pdfs etc.
    starship # Customizable shell prompt
    tmux # Terminal multiplexer
    tokei # Code statistics
    tree # Directory structure viewer
    zoxide # Smart directory navigation

    # ===== Monitoring =====
    asitop # Apple Silicon resource monitor
    btop # Resource monitor
    clamav # Antivirus tool
    dust # Disk usage analyzer
    htop # Process viewer
    trufflehog # Monitor for credential leakage

    # ===== File Management =====
    p7zip # unzip z7 files
    pdftk # Process PDFs
    ranger # Terminal file manager
    xz # Compression utilities

    # ===== Text Processing =====
    jq # JSON processor
    yq # yaml processor
    neovim # Modern Vim fork (with plugins)

    # ===== Security =====
    keychain # Enables long-running ssh-agent
    gnupg # Encryption toolkit
    git-crypt # Encrypt files in git repo

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
        collection-latexextra
        collection-fontsrecommended
        titlesec
        fontawesome5
        ;
    })
  ];

  home.file = {
    # freshclam.conf
    ".config/clamav/freshclam.conf".text = ''
      # Freshclam configuration file
      DatabaseDirectory ${config.home.homeDirectory}/.config/clamav/db
      UpdateLogFile ${config.home.homeDirectory}/.config/clamav/freshclam.log
      LogVerbose false
      LogSyslog false
      LogFacility LOG_LOCAL6
      LogFileMaxSize 2M
      LogRotate true
      LogTime true
      Foreground false
      Debug false
      MaxAttempts 5
      DatabaseMirror database.clamav.net
      DatabaseMirror db.local.clamav.net
      DatabaseDirectory ~/.config/clamav/db
      DNSDatabaseInfo current.cvd.clamav.net
      ConnectTimeout 30
      ReceiveTimeout 30
      TestDatabases yes
      ScriptedUpdates yes
      CompressLocalDatabase no
      SafeBrowsing false
      Bytecode true
    '';

    # clamd.conf
    ".config/clamav/clamd.conf".text = ''
      # clamd configuration file
      LogFile ~/.config/clamav/clamd.log
      LogTime yes
      LogVerbose no
      LogRotate yes
      LocalSocket ~/.config/clamav/clamd.sock
      FixStaleSocket yes
      User ${config.home.username}
      TCPSocket 3310
      MaxConnectionQueueLength 30
      MaxThreads 50
      ReadTimeout 300
      MaxDirectoryRecursion 20
      FollowDirectorySymlinks yes
      FollowFileSymlinks yes
      SelfCheck 600
      DetectPUA yes
      ScanPE yes
      ScanELF yes
      ScanOLE2 yes
      ScanPDF yes
      ScanHTML yes
      ScanMail yes
      ScanArchive yes
      DatabaseDirectory ~/.config/clamav/db
    '';

    # Create necessary directories
    ".config/clamav/db/.keep".text = "";
    ".config/clamav/log/.keep".text = "";
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  # NOTE: to avoid manually approving via `direnv allow`, whitelist the directories here
  # xdg.configFile."direnv/direnv.toml".text = ''
  #   [whitelist]
  #   prefix = [ "/Users/manuel/git/example" ]  # dummy example
  # '';

  programs.git = {
    enable = true;
    userName = "Manuel Kuchelmeister";
    userEmail = "makuche-github@pm.me";
    signing = {
      key = "D5E39A037F4AAE1C";
      signByDefault = true;
    };
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
        excludesfile = "~/.gitignore";
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
      note = "cd ${config.home.homeDirectory}/Library/Mobile\\ Documents/iCloud~md~obsidian/Documents/Notes && nvim .";
      todo = "nvim ${config.home.homeDirectory}/Library/Mobile\\ Documents/iCloud~md~obsidian/Documents/Notes/todo.md";
      tm = "tmux";
      tma = "tmux attach";
      tmd = "tmux detach";
      lg = "lazygit";
      htop = "btop";
      rebuild = "darwin-rebuild switch --flake ~/git/config --show-trace --impure";
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
      export PATH="${config.home.homeDirectory}/Applications/Ghostty.app/Contents/MacOS:$PATH"
      export PATH=/usr/local/clamav/bin:/usr/local/clamav/sbin:$PATH
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
      setopt INC_APPEND_HISTORY
      export EDITOR=neovim
    '';
  };
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
