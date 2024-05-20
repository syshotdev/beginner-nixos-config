{config, lib, ...}:
let 
  # Replace example with correct option from home.nix
  cfg = config.enableCategories.example; 
in {
  # An if condition that asks "am I enabled?".
  # This is the only way that doesn't cause infinite recursion
  config = lib.mkIf cfg.enable {
    example = import ./example;
  };
}
