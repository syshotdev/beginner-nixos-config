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
- Run `home-manager switch --flake .#username@hostname` to apply your home
  configuration.
  - If you don't have home-manager installed, try `nix shell nixpkgs#home-manager`.

And that's it, really! You're ready to have fun with your configurations using
the latest and greatest nix flake-enabled command UX.

## Configuration structure

What is a module? It's simple. It's a file of code that does stuff.
An example: steam.nix, adds steam to your system and configures it.

You'll have to understand the file structure of this repo in order to add users, computers, and packages.

- flake.nix
- modules
  - home
  - system

- computers  (Houses all of the computer-specific configurations)
  - default
    - base.nix
  - nixos
    - configuration.nix (Imports default/base.nix, which has all of the shared configs)
    - hardware-configuration.nix (Computer hardware stuff, automatically generated)

- users
  - default
    - default.nix
  - {user}
    - default.nix

Here's how to read this:
Each bullet point has a file, and anything to the right and down of that file is imported.


The `modules` directory has two parts. `home` and `system`.
`home` is all of the packages that can be imported via *home-manager*,
and `system` is stuff that configures the system as a whole, like drivers and base apps.

`configuration.nix` imports modules for the entire system, like drivers and system-level packages.
It also defines what users it uses on the system.

`users` is a directory that has configurations for specific users, like username, packages, and
user-specific configurations.

## Defining a new computer

Assuming you are cd'ed in the "nixos-config" directory, you can run these commands to make a new computer configuration.
Note: COMPUTER_NAME should be changed to what you want your computer to be called
```bash
cd computers
mkdir COMPUTER_NAME
cp nixos/configuration.nix COMPUTER_NAME
```
To explain what these commands do,
`cd` goes into a directory, this case the *computers* directory
`mkdir` (mk)es (dir)ectory, calls it whatever you specified
`cp` means *copy*, and it takes a source path and a destination path 
This use of `cp` copies my configuration.nix to your computer's configuration folder

Now you need to add your hardware-configuration.nix to your computer configuration.
Usually your hardware-configuration is located at `/etc/nixos/` but maybe your computer is different.
```bash
cp /etc/nixos/hardware-configuration.nix ./COMPUTER_NAME
```

Lastly, go into the flake.nix at the top of the repo and change hostname to "COMPUTER_NAME"
```bash
cd .. # Go up one level
```
Find this line in the flake.nix file, replace COMPUTER_NAME with what your computer config was called
```nix
# flake.nix
hostname = "COMPUTER_NAME";
```

## Defining a new user

To add a new user, cd into the `users` directory and copy the default.
(Replace USER with the username that you want)
```bash
cd users/
cp -r default USERNAME
```

Now, edit the text inside of the USERNAME/default.nix
You'll find lines named user, nickname, and email. Fill those in.
```nix
# USERNAME.nix
user = "default";
nickname = "default3301";
email = "default@default.com";
```

Nickname means online name, which could be the same as your computer USERNAME.
Save the file.

Next, in flake.nix on the top folder, edit the file and find the line named homeConfigurations

```nix
# flake.nix
homeConfigurations = {
  ...
}
```
Copy the `"default@${hostname}"` all the way curly bracket after `modules`,
and paste it back into homeConfigurations as it looks now.
Rename all *default*'s in your new copied code to what your USERNAME is.

Lastly, edit your computer's configuration.nix and find the lines where users.users is defined.
```nix
users.users = {
  "neck" = {
    ...
  };
};
```
You can replace the "neck" with your USERNAME, or make a new user with your USERNAME.

## Changing packages per-user

Go into the users/USERNAME/default.nix and you'll find `imports`.
Or for packages that you don't need to configure: `home.packages` and [add any package you want.](search.nixos.org)

## Applying the configuration

Earlier there were commands for building the configuration.
Here they are now, you can run them (hopefully) without any hiccups.

- Make sure you're running Nix 2.4+, and opt into the experimental `flakes` and `nix-command` features:
```bash
# Should be 2.4+
nix --version
export NIX_CONFIG="experimental-features = nix-command flakes"
```

- Run `sudo nixos-rebuild switch --flake .#hostname` to apply your system
  configuration.
- Run `home-manager switch --flake .#username@hostname` to apply your home
  configuration.
  - If you don't have home-manager installed, try `nix shell nixpkgs#home-manager`.

