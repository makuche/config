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

    # Monitoring tools
    asitop # Apple Silicon resource monitor
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

  # VM-specific environment variables
  programs.zsh.initContent = ''
    export AZCOPY_AUTO_LOGIN_TYPE=AZCLI  # required to use azcopy after az login
  '';
}
