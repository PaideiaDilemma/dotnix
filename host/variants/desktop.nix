{pkgs, ...}: {
  users.groups.render.members = ["max"];
  hardware.amdgpu.opencl.enable = true;
  nixpkgs.config.rocmSupport = true;
  services.ollama.rocmOverrideGfx = "10.3.0";
  #services.ollama.acceleration = "rocm";
  host.localllm.enable = true;

}
