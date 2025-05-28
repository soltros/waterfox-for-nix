{ config, lib, pkgs, ... }:

##############################################################################
# NixOS module: programs.waterfox
##############################################################################
let
  # Re-use your existing derivation
  waterfox = pkgs.callPackage ./default.nix { };
in
with lib;
{
  ###### 1. Option ##########################################################
  options.programs.waterfox.enable =
    mkEnableOption "the Waterfox binary web browser";

  ###### 2. Implementation ##################################################
  config = mkIf config.programs.waterfox.enable {
    environment.systemPackages = [ waterfox ];
  };
}
