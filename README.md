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

### 2 · Generate new SHA for default.nix

```bash
cd /etc/nixos/
nix-shell -p jq
sh update-default-nix.sh      # rewrites default.nix with new version + hash
```

### 3 · Add **waterfox.nix** to your imports:
```
{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./waterfox-for-nix/waterfox.nix
    ...
  ];
```
### 4 · Add to configuration.nix and rebuild

```
programs.waterfox.enable = true;
```

```bash
sudo nixos-rebuild switch
```

Waterfox will now live in `/run/current-system/sw/bin/waterfox` for **every
user** and persist across generations.

#### Updating later

```bash
cd /etc/nixos/waterfox-for-nix
sh update-default-nix.sh      # bump Waterfox to a new version & new SHA hash
sudo nixos-rebuild switch
```

Waterfox itself is [MPL‑2.0](https://www.mozilla.org/MPL/2.0/). 
