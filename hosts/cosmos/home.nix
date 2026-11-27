{pkgs, ...}: {
  imports = [../../common/home-manager];

  home.packages = with pkgs; [
    azure-cli # brew formula became a cask; add extensions via azure-cli.withExtensions
    go-task # `task` runner
    sqlcmd # SQL Server CLI
    viddy # modern `watch`
  ];

  programs.git.signing.key = "AA7B304D0375E65B";

  programs.zsh.profileExtra = ''
    source ~/.orbstack/shell/init.zsh 2>/dev/null || :
  '';

  # CLI bundled with the pritunl cask, not on PATH by default
  programs.zsh.shellAliases.pritunl-client = "/Applications/Pritunl.app/Contents/Resources/pritunl-client";

  # bump all flake inputs (incl. the pinned brew taps), rebuild, then upgrade brew packages in one process (one password prompt)
  programs.zsh.shellAliases.system-upgrade ="nix flake update --flake ~/git/config && sudo darwin-rebuild switch --flake ~/git/config#cosmos && brew upgrade";

  # dg ships no zsh completion, and `dg --install-completion` can't write to the read-only ~/.zshrc
  programs.zsh.initContent = ''
    _dg_completion() {
      eval $(env _TYPER_COMPLETE_ARGS="''${words[1,$CURRENT]}" _DG_COMPLETE=complete_zsh dg)
    }
    compdef _dg_completion dg
  '';
}
