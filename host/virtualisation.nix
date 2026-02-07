{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotnix;
in {
  options.dotnix.libvirtd.enable = lib.mkOption {
    default = true;
    description = "Enable libvirtd";
    type = lib.types.bool;
  };

  config = {
    virtualisation = {
      docker.enable = true;

      podman = {
        enable = true;
        #dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      libvirtd = lib.mkIf cfg.libvirtd.enable {
        enable = true;
      };

      kvmgt.enable = true;
    };

    # TODO: do this in the user's config
    users.groups.docker.members = ["max" "nixos"];
    users.groups.libvirtd.members = lib.optionals cfg.libvirtd.enable ["max" "nixos"];
    users.groups.kvm.members = ["max" "nixos"];

    environment.systemPackages = with pkgs; [
      podman-compose
      #docker-compose
    ];
  };
}
