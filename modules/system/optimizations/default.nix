{
  gpu = ./gpu; # General GPU settings like optimizations
  nvidia = ./gpu/nvidia;
  #amd = import ./gpu/amd; # Will add support when somebody gives me amd testbench

  cpu = ./cpu; # General CPU optimizations (Find battery life settings there)
  intelCPU = ./cpu/intel;
  #amdCPU = import ./cpu/amd; # Will add support when somebody gives me amd testbench
}
