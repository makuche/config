{
  config,
  pkgs,
  ...
}: {
  # Import common configuration
  imports = [../../common/home-manager];

  # cosmos-specific packages
  home.packages = with pkgs; [
    # Add cosmos-specific packages here
  ];

  # cosmos-specific shell configuration
  programs.zsh.initContent = ''
    # Add cosmos-specific shell config here
  '';
}
