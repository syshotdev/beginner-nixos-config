{config, lib, ...}:
let 
  cfg = config.enableCategories.development; 
in {
  # An if condition that asks "am I enabled?".
  # This is the only way that doesn't cause infinite recursion
  config = lib.mkIf cfg.enable {
    git = import ./git;
    neovim = import ./neovim;
  };
}
