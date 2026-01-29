{
  config,
  pkgs,
  ...
}: {
  # Import common configuration
  imports = [../../common/home-manager];

  programs.git.signing.key = "AA7B304D0375E65B";

  # cosmos-specific packages
  home.packages = with pkgs; [
    # Add cosmos-specific packages here
  ];

  # cosmos-specific shell configuration
  programs.zsh.initContent = ''
    # Add cosmos-specific shell config here
  '';
}
