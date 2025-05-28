# waterfox-for-nix
A simple way to install Waterfox on NixOS as a package, rather than needing to use Flatpak.


To install in your user profile, you can do:
```
sudo git clone https://github.com/soltros/waterfox-for-nix.git
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

Paste anywhere inside the top‑level set:

```nix
# --- Waterfox system-wide (local checkout) -------------------------------
let
  waterfox = import /etc/nixos/waterfox-for-nix { inherit pkgs; };
in {
  environment.systemPackages = [ waterfox ];
}
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
