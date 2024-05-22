{...}:
{
  boot.kernelParams = ["intel_pstate=active"]; # Makes browsing less laggy
  services.auto-cpufreq.enable = true; # Optimizations using cpufreq utility

  # These settings are probably for laptops
  services.thermald.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
}
