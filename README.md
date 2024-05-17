## A Simple NixOS Configuration

NixOS is an operating system based on the package manager 'nix'.
This repo will get you working a working configuration quickly and will teach you 
about nix (the language) and how to configure stuff without the thousands of pitfalls I had to endure.

Some links that may be of use:
https://nixos.org/learn/
https://github.com/Misterio77/nix-starter-configs/tree/main # Original configuration this is based on


How to start this:

First, clone this repo to somewhere. I'd put it in your home directory somewhere, for example
in the `Documents` folder, and name it something like `nixos-config`.

```bash
cd ~/Documents
git clone (TODO: PUT REPO HERE) nixos-config # Will clone this repo to folder "nixos-config"
cd nixos-config
```
- Make sure you're running Nix 2.4+, and opt into the experimental `flakes` and `nix-command` features:
```bash
# Should be 2.4+
nix --version
export NIX_CONFIG="experimental-features = nix-command flakes"
```

## Usage

- Run `sudo nixos-rebuild switch --flake .#hostname` to apply your system
  configuration.
    - If you're still on a live installation medium, run `nixos-install --flake
      .#hostname` instead, and reboot.
- Run `home-manager switch --flake .#username@hostname` to apply your home
  configuration.
  - If you don't have home-manager installed, try `nix shell nixpkgs#home-manager`.

And that's it, really! You're ready to have fun with your configurations using
the latest and greatest nix3 flake-enabled command UX.

## How to enable / add modules

What is a module? It's simple. It's a file of code that does stuff.
An example: steam.nix, adds steam to your system and configures it.

Next, you'll have to understand the file structure of this repo in order to add packages.

- flake.nix
  - nixos/configuration.nix
    - (Imports modules/nixos)
    - nixos/hardware-configuration.nix
    - nixos/base.nix

  - home-manager/home.nix
    - (Imports modules/home-manager)

Here's how to read this:
Each bullet point has a file, and anything to the right of that file is imported.

`configuration.nix` imports modules for the entire system, like drivers and whatever. 
`home.nix` imports stuff that is *per user*.

TODO:
Complete the file-structure diagram, add "host" systems, add a way to add users,
each user/host should be configurable in terms of what is imported, put `base.nix`
and whatever in a place that makes sense, rename all the folders to make sense.
