#!/usr/bin/env bash
# This script basically sets some environment variables to vr run better 
# Requires steam to be installed
#
# Btw I removed quotes for a reason, bash keeps thinking they're strings when they should be paths


#steam_location="~/.steam/steam"
steam_location=~/.local/share/Steam

# Other steam options https://www.reddit.com/r/linux_gaming/comments/p6176x/comment/h9iwukh/
sudo setcap CAP_SYS_NICE=eip ~/.steam/steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher

export VRCLIENT=$steam_location/steamapps/common/SteamVR/bin/vrclient.so
export STOREPATH=$(nix-store -qR $(which steam) | grep steam-fhs)/lib64
export LD_LIBRARY_PATH=$steam_location/steamapps/common/SteamVR/bin/linux64
export VR_RUNTIME=$steam_location/steam/steamapps/common/SteamVR
export VRCOMPOSITOR_LOG_LEVEL="warn"
export VR_APP_CONFIG_PATH=~/.config/vr-apps
export XDG_RUNTIME_DIR=run/user/$(id -u)
#export DISPLAY=":0"
#export LIBGL_DRIVERS_PATH="/usr/lib/xorg/modules/drivers"
export OPENXR_RUNTIME="Monado"
#export MESA_GL_VERSION_OVERRIDE="4.5"
#export VK_ICD_FILENAMES="/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json"
VK_DRIVER_FILES=/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json

# Patch the VR client
echo "Patching VR client at $VRCLIENT with rpath $STOREPATH"
patchelf --set-rpath "$STOREPATH" "$VRCLIENT"

# Run the application with steam-run, passing all arguments
steam-run "$@"

