# !/bin/bash
# Credits to ChatGPT for making this entire script

# Exit if no argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <computer_name>"
    exit 1
fi

export computer_name="$1"

# Remove the computer_name argument
shift

# Find the nearest flake.nix in the current directory or upwards
export flake_file=$(find "$(pwd)" -name "flake.nix" -print -quit)
if [ -z "$flake_file" ]; then
    echo "No flake.nix found in the current directory or any parent directories."
    exit 1
fi

# Generate hardware-configuration.nix
sudo nixos-generate-config

# Copy the generated hardware-configuration.nix to the appropriate directory
config_path="./computers/$computer_name"
mkdir -p "$config_path"
cp -f /etc/nixos/hardware-configuration.nix "$config_path/"

# Replace "computer='<previous_name>'" with "computer='COMPUTER_NAME'"
sed -i "s/computer = \"[^\"]*\";/computer = \"$computer_name\";/" "$flake_file"

# Set up necessary environment variables and packages
export NIX_CONFIG="experimental-features = nix-command flakes"

echo "Rebuilding..."
# Rebuild the system with the specified flake, passing in any other arguments
nix-shell -p git home-manager --run "
    sudo nixos-rebuild switch --flake .#$computer_name $@
"
