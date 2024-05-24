{...}:
{
  services.auto-cpufreq.enable = true; # Optimizations using cpufreq utility

  # These settings are probably for laptops
  # But who cares they don't hurt (I think)
  services.thermald.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
}
