# Config

Declarative macOS system configuration using Nix flakes, nix-darwin, and home-manager.

## Overview

- **Nix**: Package management and system configuration
- **nix-darwin**: macOS-specific system configuration
- **home-manager**: User environment management
- **Homebrew**: GUI applications via nix-homebrew integration

GUI apps use Homebrew casks while CLI tools use Nix packages.

## Project Structure

```
config/
├── flake.nix              # Main entry point - defines all machine configurations
├── flake.lock             # Locked dependency versions
├── common/                # Shared configurations (applied to ALL machines)
│   ├── darwin/            # macOS system settings (keyboard, fonts, Homebrew base)
│   └── home-manager/      # User environment (packages, dotfiles, shell config)
├── hosts/                 # Machine-specific configurations
│   ├── atlas/             # Primary machine (user: manuel)
│   │   ├── configuration.nix  # System-level packages, Homebrew casks
│   │   └── home.nix           # User-level packages
│   └── cosmos/            # Secondary machine (user: manuel)
│       ├── configuration.nix
│       └── home.nix
├── assets/                # Standalone config files (tmux.conf, aerospace.toml, etc.)
├── nvim/                  # Neovim configuration (Lua)
├── ghostty/               # Terminal emulator config
├── lazygit/               # Git UI config
└── gh/                    # GitHub CLI config
```

## Multi-Machine Management

The `flake.nix` defines multiple `darwinConfigurations`, each representing a machine:

```nix
darwinConfigurations."atlas" = nix-darwin.lib.darwinSystem {
  modules = [
    ./common/darwin/default.nix      # Shared macOS settings
    ./hosts/atlas/configuration.nix  # Machine-specific system config
    home-manager.darwinModules.home-manager
    {
      home-manager.users.manuel = import ./hosts/atlas/home.nix;
    }
  ];
};
```

### Configuration Layering

1. **common/darwin/** - Applied first, sets base macOS defaults
2. **common/home-manager/** - Imported by each host's `home.nix`, provides shared packages/dotfiles
3. **hosts/{machine}/** - Machine-specific overrides and additional packages

### Adding a New Machine

1. Create `hosts/{new-machine}/configuration.nix` and `home.nix`
2. Import `../../common/home-manager` in the new `home.nix`
3. Add a new `darwinConfigurations."{hostname}"` block in `flake.nix`
4. Rebuild: `darwin-rebuild switch --flake . --impure`

## Key Files

| File | Purpose |
|------|---------|
| `common/home-manager/default.nix` | Main shared config: packages, git, zsh, tmux |
| `common/darwin/default.nix` | macOS system defaults and Homebrew base config |
| `hosts/*/configuration.nix` | Machine-specific Homebrew casks and system settings |
| `assets/tmux.conf` | Tmux keybindings and settings |
| `assets/aerospace.toml` | Tiling window manager config |
| `nvim/init.lua` | Neovim entry (uses Lazy plugin manager) |

## Conventions

- **Shared packages** go in `common/home-manager/default.nix`
- **Machine-specific packages** go in `hosts/{machine}/home.nix` or `configuration.nix`
- **Homebrew casks** (GUI apps) defined in host's `configuration.nix`

## Initial Setup

### 1. Install Xcode Command Line Tools
```bash
xcode-select --install
```

### 2. Install Nix (using Determinate Systems installer)
```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

### 3. Configure Shell (optional)
The Determinate installer handles this automatically. If using the official installer, append to `.zshrc`:
```bash
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
```

### 4. Set Hostname (optional)
If you want `darwin-rebuild` to auto-detect your configuration:
```bash
sudo scutil --set LocalHostName atlas  # or cosmos
sudo scutil --set ComputerName atlas
```
Otherwise, specify explicitly with `--flake .#atlas`.

### 5. Clone and Build
```bash
git clone <repo-url> ~/git/config
cd ~/git/config

# First build (uses hostname for auto-detection, or specify .#<machine>)
nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake .
```

## Usage

### Rebuild System
```bash
darwin-rebuild switch --flake . --impure
```

### Update Packages
```bash
nix flake update
darwin-rebuild switch --flake . --impure
```

### Development Shell
```bash
nix-shell --command zsh
```

## Machines

| Hostname | User | Purpose |
|----------|------|---------|
| atlas | manuel | Primary development machine |
| cosmos | manuel | Secondary machine |
