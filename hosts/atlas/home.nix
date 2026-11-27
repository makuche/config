{pkgs, ...}: {
  # Import common configuration
  imports = [../../common/home-manager];

  home.packages = with pkgs; [
    exiftool # read/write image metadata
    trivy # vulnerability scanner
  ];

  programs.git.signing.key = "D5E39A037F4AAE1C";

  # MacBook-specific initialization
  programs.zsh.initContent = ''
    if ! [ "$TERM_PROGRAM" = tmux ]; then
      echo 'INFO: tmux not active, consider starting...'
    fi

    source ~/.api

  '';
}
