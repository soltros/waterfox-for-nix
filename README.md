# waterfox-for-nix
A simple way to install Waterfox on NixOS as a package, rather than needing to use Flatpak.


To install in your user profile, you can do:
```
git clone https://github.com/soltros/waterfox-for-nix.git
cd waterfox-for-nix
sh update-default-nix.sh
nix-env -f . -iA waterfox
```
If you want to add this system wide, you can do:

### 1 · Clone once

```bash
cd  /etc/nixos/waterfox-for-nix
sudo git clone https://github.com/soltros/waterfox-for-nix 
```

### 2 · (Optional) bump to the newest Waterfox

```bash
cd /etc/nixos/waterfox-for-nix
sh update-default-nix.sh      # rewrites default.nix with new version + hash
```

### 3 · Add **one** code block to `/etc/nixos/configuration.nix`

Add waterfox to your imports:

```nix

```

For example: 
```
{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./waterfox.nix
    ./amdgpu.nix
    ./apps.nix
    ./bootloader.nix
    ./derriks-apps.nix
    ./docker-support.nix
    ./fish-shell-support.nix
    ./flake-support.nix
    ./flatpak.nix
    ./fstrim.nix
    ./gamemode.nix
    ./gnome-shell.nix
    # ./cinnamon.nix
    # ./pantheon.nix
    # ./pantheon-packages.nix
    # ./kde-plasma6.nix
    ./keymap.nix
    ./networking.nix
    ./pipewire-support.nix
    ./ssh-server.nix
    ./steam.nix
    ./swapfile.nix
    ./tailscale-support.nix
    ./timezone-localization.nix
    ./unfree-packages.nix
    ./unsecure-packages.nix
    ./user-account.nix
    ./virtualization-support.nix
  ];
```
### 4 · Rebuild

```bash
sudo nixos-rebuild switch
```

Waterfox will now live in `/run/current-system/sw/bin/waterfox` for **every
user** and persist across generations.

#### Updating later

```bash
cd /etc/nixos/waterfox-for-nix
sh update-default-nix.sh      # bump version & hash
sudo nixos-rebuild switch
```

Waterfox itself is [MPL‑2.0](https://www.mozilla.org/MPL/2.0/).  
All packaging files in this repo are released under the same license.  
