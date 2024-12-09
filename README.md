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

### Setting up git(config)
The gitconfig currently contains a label for a GPG key, used for signing commits. At the moment, this is a randomly generated reference and hence has to be adapted when installing this config with another Github account or GPG key.


### I/O
This is macOS specific, for changing the key repetition rate (run in a shell):
```
defaults write -g KeyRepeat -int 1 
defaults write -g InitialKeyRepeat -int 10
```

General settings:
- CAPS->ESC

### Roadmap: Migration to working on a VM
I want to shift all my development related work to a graphical virtual Unix machine that will run on a MacOS host. This will allow me to use the great peripherals and ecosystem of maCOS, while still developing on a Unix machine as I have already been doing for a while. Will this migration/configuration effort be worth it? I am not sure at, BUT it will be fun and also a fantastic learning experience!

#### Future setup
The Mac machine will be configured using nix-darwin, in combination with home-manager, while the virtual machines configuration might depend on the distribution that I am going to use.

#### Installation of nix-darwin
1. Install nix via `sh <(curl -L https://nixos.org/nix/install)`
2. Enable flakes via `echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf`
3. Restart nix via `sudo launchctl kickstart -k system/org.nixos.nix-daemon`
4. Create `~/.config/nix-darwin/` folder and add flake via `nix flake init -t nix-darwin`
5. Substitute the computers network name via `sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix`
6. Optional: if bashrc, zshrc and /etc/nix/nix.conf file exist, rename them 
7. First build via `nix run nix-darwin --extra-experimental-features 'nix-command flakes'  -- switch --flake ~/.config/nix-darwin`
8. Rebuild later with `darwin-rebuild switch --flake ~/.config/nix-darwin --show-trace --impure`

