{ lib, pkgs, ... }:

let
  waterfox = pkgs.callPackage ./default.nix { };
in
with lib;
{
  options.programs.waterfox.enable = mkEnableOption "the Waterfox web browser";

  config = mkIf config.programs.waterfox.enable {
    environment.systemPackages = [ waterfox ];
  };
}
