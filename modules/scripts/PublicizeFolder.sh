# !/bin/bash

# If first argument exists, use that, otherwise current working directory
directory_to_publicize="${1:-$(pwd)}"

# Make files EXECUTABLE, READABLE, AND WRITABLE, RECURSIVELY
sudo chmod -R 7777 $directory_to_publicize
# Allow any user from the "wheel" group to move/delete any file
sudo chown root:wheel -R $directory_to_publicize
# Every file created in this directory inherits permissions (Doesn't seem to work)
sudo chmod g+s $directory_to_publicize
