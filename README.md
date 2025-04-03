# Config

This repo contains my `~/.config` directory with declarative system configurations using a combination of Nix, home-manager, and nix-darwin. It enables reproducible environment setup across macOS machines with minimal manual intervention.

## System Overview
- **Nix**: Package management and system configuration
- **nix-darwin**: macOS-specific system configuration
- **home-manager**: User environment management
- **Homebrew**: Additional macOS (and GUI) applications via nix-homebrew integration

I've moved most GUI apps to Homebrew instead of home-manager so the home-manager setup can also be used on resource-restricted Linux systems (e.g., Raspberry Pis). Additionally, Homebrew uses cached binaries while Nix compiles from source, making it faster and more convenient for certain applications.

## Initial Setup

The following describes how to set up nix-darwin and home-manager for the cases 1) when using the configuration files and 2) when starting from scratch (i.e. with empty home.nix files etc.). The steps for starting from scratch are marked via "Optional".

### 1. Install Nix
```bash
sh <(curl -L https://nixos.org/nix/install)
```

### 2. Configure Shell
Append to `.zshrc`:
```bash
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
```

### 3. Install Home Manager
```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Optional: Add packages and other settings to this file
vim /Users/manuel/.config/home-manager/home.nix
```

### 4. Install nix-darwin
```bash
# Enable flakes
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
sudo launchctl kickstart -k system/org.nixos.nix-daemon

# Optional: Create nix darwin flake config
mkdir -p ~/.config/nix-darwin
nix flake init -t nix-darwin
sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix


# Optional: backup existing configs if present
# mv ~/.bashrc ~/.bashrc.backup
# mv ~/.zshrc ~/.zshrc.backup
# mv /etc/nix/nix.conf /etc/nix/nix.conf.backup

# First build
# NOTE: When re-using the config folder, make sure to substitute darwinConfigurations."HOST" with the correct host name (run scutil --get LocalHostName on MacOS)
nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake ~/.config
```

## Daily Usage

### System Management
Rebuild your system after configuration changes:
```bash
darwin-rebuild switch --flake ~/.config/nix-darwin --show-trace --impure
# Or use the alias
rebuild
```

### Home Manager (on non-darwin systems)
In this setup, using home-manager directly is not required. However, on other host systems:
```bash
home-manager switch
home-manager generations
<GENERATION>/activate
```

### Git Configuration
The gitconfig contains a label for a GPG key used for signing commits. This will need to be adapted when installing with another GitHub account or GPG key.

### Package Management
Package versions (including Homebrew packages) are frozen by the flake.lock file for reproducibility. To update:
```bash
# Update all flake inputs
nix flake update

# Or update specific inputs
nix flake lock --update-input nixpkgs
nix flake lock --update-input home-manager

# After updating the lock file, rebuild the system
darwin-rebuild switch --flake ~/.config/nix-darwin --impure
```

## Tasks

### High Priority
- [ ] fix `--impure` flag requirement in darwin-rebuild
- [ ] proper symlinks to `~/.config` for better file management
- [ ] better documentation for the rebuild command

### Medium Priority
- [ ] simpler update mechanism for common package updates
- [ ] GPG key configuration for git commit signing
- [ ] Better integrate home-manager with nix-darwin

### Future Work
- [ ] migrate to a graphical virtual Linux machine running on macOS host
  - pro: macOS peripherals and ecosystem while using Linux for development
  - configure the VM using the same declarative approach
- [ ] consolidate duplicate configuration between dotfiles
