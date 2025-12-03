{pkgs, ...}: {
  # users.groups.render.members = ["max"];
  #hardware.amdgpu.opencl.enable = true;
  #nixpkgs.config.rocmSupport = true;
  #services.ollama.rocmOverrideGfx = "10.3.0";
  #services.ollama.acceleration = "rocm";
  host.localllm.enable = false;

  #services.desktopManager.plasma6.enable = true;

  services.nix-serve = {
    enable = false;
    secretKeyFile = "/var/desktop-cache-local-priv-key.pem";
    port = 9777;
  };

  services.pipewire.wireplumber.extraConfig = {
    "51-scarlet-solo" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {
              "device.name" = "~alsa_card.usb-Focusrite*";
            }
          ];
          actions = {
            update-props = {
              "api.acp.probe-rate" = 44100;
            };
          };
        }
      ];
    };
  };
}
