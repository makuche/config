# Config

This repository contains the state of my `~/.config` directory. 

## Setting up new Unix machine
### Software
- Install Nix 
- Install home-brew
- Append this to the .zshrc:
```
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

export PATH=/opt/homebrew/bin:$PATH
```
- The step above might need to be repeated after a macOS update, according to: https://stackoverflow.com/questions/70733236/nixos-installation-issue-command-not-found-nix
- Nix compiles from source and this could take a long time and require a lot of dependencies. 
  Homebrew uses cached binaries, so much faster and convenient for GUI applications, so consider using it in parallel

### I/O
- Point CAPS->ESC
- Revert scrolling

### Installing Home Manager
```
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Add packages and other settings to this file
vim /Users/manuel/.config/home-manager/home.nix     
```

### Using Home Manager
```home-manager switch
home-manager generations
<GENERATION>/activate
```