# !/bin/bash
# Credits to ChatGPT for making this entire script

# Exit if no argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <computer_name>"
    exit 1
fi

computer_name="$1"

# Find the nearest flake.nix in the current directory or upwards
flake_file=$(find "$(pwd)" -name "flake.nix" -print -quit)
if [ -z "$flake_file" ]; then
    echo "No flake.nix found in the current directory or any parent directories."
    exit 1
fi

# Set up necessary environment variables and packages
export NIX_CONFIG="experimental-features = nix-command flakes"
nix-shell -p git
nix shell nixpkgs#home-manager

# Replace "computer='<previous_name>'" with "computer='COMPUTER_NAME'"
sed -i "s/computer='[^']*'/computer='$computer_name'/" "$flake_file"

# Generate hardware-configuration.nix
sudo nixos-generate-config --root /

# Copy the generated hardware-configuration.nix to the appropriate directory
config_path="computers/$computer_name"
mkdir -p "$config_path"
cp -f /etc/nixos/hardware-configuration.nix "$config_path/"

# Rebuild the system with the specified flake
sudo nixos-rebuild switch --flake .#"$computer_name"
