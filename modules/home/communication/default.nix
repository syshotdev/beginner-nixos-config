{config, lib, ...}:
let 
  cfg = config.enableCategories.communication; 
in {
  # An if condition that asks "am I enabled?".
  # This is the only way that doesn't cause infinite recursion
  config = lib.mkIf cfg.enable {
  };
}
