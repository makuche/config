{...}: {
  # Import common configuration
  imports = [../../common/home-manager];

  programs.git.signing.key = "AA7B304D0375E65B";
}
