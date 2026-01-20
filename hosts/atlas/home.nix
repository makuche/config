{
  config,
  pkgs,
  ...
}: {
  # Import common configuration
  imports = [../../common/home-manager];

  # MacBook-specific packages
  home.packages = with pkgs; [
    # GitHub CLI
    gh

    # Additional utilities
    clamav

    # Documentation & Publishing
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
  ];

  # ClamAV configuration
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

  # MacBook-specific initialization
  programs.zsh.initContent = ''
    export PATH=/usr/local/clamav/bin:/usr/local/clamav/sbin:$PATH

    if ! [ "$TERM_PROGRAM" = tmux ]; then
      echo 'INFO: tmux not active, consider starting...'
    fi

    source ~/.api

  '';
}
