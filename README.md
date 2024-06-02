## A Simple NixOS Configuration

NixOS is an operating system based on the package manager 'nix'.
This repo will get you working a working configuration quickly and will teach you 
about nix (the language) and how to configure stuff without the thousands of pitfalls I had to endure.

Some links that may be of use:

- https://nixos.org/learn/
- https://github.com/Misterio77/nix-starter-configs/tree/main (Original configuration this is based on)
- https://github.com/EmergentMind/nix-config (Documented(ish) nix config)
- https://github.com/MattCairns/nixos-config (I stole stuff from his repo)

## Features

- Mostly documented
- Flakes (I still don't know what this means)
- Optional unstable packages (for more up-to-date packages)
- Home-manager for user-specific configurations
- Computer-specific configurations
- Custom-package examples
  - Appimage
  - From github
- Neatly organized modules
  - System stuff (drivers, system theme, system-wide programs, etc.)
  - User stuff (git, neovim, user-specific options) 
  - Overlays (Only used for unstable-packages)
  - Custom-packages (Examples of grabbing from online and building)
- A sensible file structure
- Simple (as much as feasible)
- A quickstart


# Specific modules
- A configured Neovim
- Automatically setting up git
- Steam
- GPU drivers
  - You manually import these
- CPU optimizations 
  - (Just so you know most Linux distros have these automatically, not NixOS)
- Other things

# (Import these from users/neck configs)
- Minecraft (kinda)
- Godot-mono 4.2
- Many programs from https://search.nixos.org

I have a TODO.txt in this repo if you're curious.

## General configuration quickstart

Notes: 
- I'm pretty sure this ONLY works on NixOS
- Only tested with Intel CPU and Nvidia graphics but should work (as it's basically stock)

```bash
export NIX_CONFIG="experimental-features = nix-command flakes"
nix-shell -p git
nix shell nixpkgs#home-manager
cd ~/Documents
git clone https://github.com/syshotdev/beginner-nixos-config.git nixos-config 
cd nixos-config
nixos-generate-config
cp /etc/nixos/hardware-configuration.nix computers/default
git add .
```

It's at this point that you should edit your flake.nix file, and find the line named "computer".
Change that line to (computer="default") and run the last commands.

```bash
sudo nixos-rebuild switch --flake .#default
```

To explain what's happening here, we're making sure we have dependencies to compile nixos,
going into the `Documents` folder, cloning this repository, and we compile the computer "default" and the user "default".


## Configuration structure

It's best to understand this structure (To know where to put things) but you can skip over this section.

- `flake.nix` is the entrypoint to this configuration, defines nixpkgs source + global variables
- `modules`, directory with all configured programs
  - `home` is user-specific packages
  - `system` is for the entire system
  - `custom-modules` is things that you can't find at https://search.nixos.org
  - `overlays` is currently just for unstable packages (actual use is `overlaying` patches onto whatever)

- `computers` houses all of the computer-specific configurations
  - `base.nix` is the base settings for all computers (like boot preferences, timezone, etc)
  - `default` is a computer named `default`.
    - `configuration.nix` is machine-specific configuration, imports users and sets up the machine
  - `nixos` next 3 lines is same as last 2
    - `configuration.nix`
    - `hardware-configuration.nix (Specifically my hardware, in tutorial you'll get your own)`

- `users` all of the users for the specific computers
  - `default` is configuration dir for the user `default`
    - `base.nix` all computers share this configuration file
    - `default.nix` a user configuration specifically for a computer named `default`
  - `neck` is configuration dir for user `neck`
    - `base.nix` blah blah blah
    - `desktop.nix`

Each main folder will (in the future) have a README with more information about it's purpose.

## Defining a new computer

Assuming you are cd'ed in the "nixos-config" directory, you can run these commands to make a new computer configuration.
- Note: COMPUTER_NAME should be changed to what you want your computer to be called
```bash
cd computers/
mkdir COMPUTER_NAME
cp default/configuration.nix COMPUTER_NAME
```
To explain what these commands do:
- `cd` goes into a directory, this case the *computers* directory
- `mkdir` (mk)es (dir)ectory, calls it whatever you specified
- `cp` means *copy*, and it takes a source path and a destination path 
This use of `cp` copies the default configuration.nix to your computer's configuration folder

Now you need to add your hardware-configuration.nix to your computer configuration.
Usually your hardware-configuration is located at `/etc/nixos/` but maybe your computer is different.
```bash
cp /etc/nixos/hardware-configuration.nix ./COMPUTER_NAME
```

```bash
cd .. # Go up one level
```
Find this line in the flake.nix file, replace COMPUTER_NAME with what you named your computer and save the file.
```nix
# flake.nix
computer = "COMPUTER_NAME";
```

## Defining a new user

To add a new user, cd into the `users` directory and copy the default.
(Replace USERNAME with the username that you want, COMPUTER_NAME with your computer name)
```bash
cd users/
mkdir USERNAME
cp default/default.nix USERNAME/COMPUTER_NAME.nix
cp default/base.nix USERNAME
```

Now, edit the text inside of the USERNAME/base.nix
You'll find lines named user, nickname, and email. Fill those in and save the file.
```nix
# USERNAME.nix

# TODO: Change these!
user = "john";
nickname = "Ilovecats0013";
email = "default@default.com";
```

In the other file USERNAME/COMPUTER_NAME.nix (basically a computer-specific configuration),
you can import/add new packages for that specific user/computer combo.

```bash
cd .. # Go to the top folder for next instruction
```
Lastly, edit your computer's configuration.nix and find the lines where users.users is defined.
Replace any mention of "default" with your USERNAME.

```nix
users.users = {
  "default" = {
    ...
  };
};

home-manager.users.default = import ../../users/default/${computer}.nix;
```

## Applying the configuration

Earlier there were commands for building the configuration.
Here they are now, you can run them (hopefully) without any hiccups.

- Make sure you're running Nix 2.4+, and opt into the experimental `flakes` and `nix-command` features:
```bash
# Should be 2.4+
nix --version
export NIX_CONFIG="experimental-features = nix-command flakes"
```

**Note:** home-manager is git sensitive. Do `git add .` in the commandline to make sure it understands
your new files/changes

- Run `sudo nixos-rebuild switch --flake .#computer` to apply your system and user configurations

## Changing packages per-user

Go into the users/USERNAME/COMPUTER_NAME and you'll find `imports`.
Or for packages that you don't need to configure: `home.packages` and [add any package you want.](https://search.nixos.org)

## Adding modules in an organized way

TODO: add an actual instructions here



## Total hours spent: like 67 hr
