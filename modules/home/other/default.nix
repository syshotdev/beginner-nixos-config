{config, lib, ...}:
with lib;
let 
  cfg = config.categories.other; 
in {
  options.categories.other.enable = mkEnableOption (mdDoc "testing of the optional configs");
  # An if condition that asks "am I enabled?".
  # This is the only way that doesn't cause infinite recursion
  config = mkIf cfg.enable {
    #imports = [ ./firefox ];
    firefox = import ./firefox;
  };
}
