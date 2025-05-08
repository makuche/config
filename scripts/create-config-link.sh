#!/bin/bash

# This script is used to create symlinks between the cloned repository
# (github.com/makuche/config) and the .config directory on Unix/Darwin
# systems.

CONFIG_REPO="$HOME/git/config"  # cloned config repo
CONFIG_DIR="$HOME/.config"

show_help() {
    echo "Usage: $0 [-s source_dir] [-d dest_dir]"
    echo "Creates symbolic links from source directory to destination directory"
    echo ""
    echo "Options:"
    echo "  -s    Source directory (default: $CONFIG_REPO)"
    echo "  -d    Destination directory (default: $CONFIG_DIR)"
    echo "  -h    Show this help message"
}

# Parse command line options
while getopts "s:d:h" opt; do
    case $opt in
        s) CONFIG_REPO="$OPTARG";;
        d) CONFIG_DIR="$OPTARG";;
        h) show_help; exit 0;;
        ?) show_help; exit 1;;
    esac
done

# Check if source directory exists
if [ ! -d "$CONFIG_REPO" ]; then
    echo "Error: Source directory $CONFIG_REPO does not exist"
    exit 1
fi

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Function to create symbolic link
create_symlink() {
    local src="$1"
    local dest="$2"
    local name=$(basename "$src")
    local dest_path="$dest/$name"

    # Check if destination already exists
    if [ -e "$dest_path" ]; then
        if [ -L "$dest_path" ]; then
            echo "Skipping $name: Symbolic link already exists"
        else
            echo "Warning: $dest_path already exists and is not a symbolic link"
            read -p "Do you want to backup and replace it? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                mv "$dest_path" "$dest_path.backup"
                ln -s "$src" "$dest_path"
                echo "Created symbolic link for $name (original backed up)"
            fi
        fi
    else
        ln -s "$src" "$dest_path"
        echo "Created symbolic link for $name"
    fi
}

# Create symlinks for all directories in the config repo
for dir in "$CONFIG_REPO"/*/ ; do
    if [ -d "$dir" ]; then
        create_symlink "$dir" "$CONFIG_DIR"
    fi
done

echo "Finished creating symbolic links... Exiting now"
