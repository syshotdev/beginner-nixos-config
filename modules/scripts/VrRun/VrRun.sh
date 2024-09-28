#!/usr/bin/env bash
# This script basically sets some environment variables to vr run better 
# Requires steam to be installed

VRCLIENT="~/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrclient.so"
STOREPATH=$(nix-store -qR $(which steam) | grep steam-fhs)/lib64

# Patch the VR client
echo "Patching VR client at $VRCLIENT with rpath $STOREPATH"
patchelf --set-rpath "$STOREPATH" "$VRCLIENT"

# Run the application with steam-run, passing all arguments
steam-run "$@"
