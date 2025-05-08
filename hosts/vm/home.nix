{
  config,
  pkgs,
  ...
}: {
  # import common configuration
  imports = [../../common/home-manager];

  # VM-specific packages
  home.packages = with pkgs; [
    # DevOps tools
    ansible # Configuration management
    docker # Containerization platform

    # Monitoring tools
    asitop # Apple Silicon resource monitor
    btop # Resource monitor
    dust # Disk usage analyzer
    htop # Process viewer

    wireshark

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

  # VM-specific shell aliases
  programs.zsh.shellAliases = {
    ls = "eza";
    ll = "eza -lahF";
    vim = "nvim";
    note = "cd ${config.home.homeDirectory}/Library/Mobile\\ Documents/iCloud~md~obsidian/Documents/Notes && nvim .";
    tm = "tmux";
    tma = "tmux attach";
    tmd = "tmux detach";
    lg = "lazygit";
    htop = "btop";
    rebuild = "darwin-rebuild switch --flake ~/.config#MKs-Virtual-Machine --show-trace --impure";
    cd = "z";
  };

  # VM-specific environment variables
  programs.zsh.initContent = ''
    export AZCOPY_AUTO_LOGIN_TYPE=AZCLI  # required to use azcopy after az login
  '';
}
