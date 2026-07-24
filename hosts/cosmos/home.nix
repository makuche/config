{...}: {
  imports = [../../common/home-manager];

  programs.git.signing.key = "AA7B304D0375E65B";

  programs.zsh.profileExtra = ''
    source ~/.orbstack/shell/init.zsh 2>/dev/null || :
  '';
}
