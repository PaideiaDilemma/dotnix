{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.host;
in
{
  options.host.libvirtd.enable = mkOption {
    default = true;
    description = "Enable libvirtd";
    type = types.bool;
  };

  config = {
    virtualisation = {
      docker.enable = true;
      podman = {
        enable = true;
        #dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      libvirtd.enable = cfg.libvirtd.enable;
    };

    # TODO: do this in the user's config
    users.groups.docker.members = [ "max" "nixos" ];
    users.groups.libvirtd.members = lib.optionals cfg.libvirtd.enable [ "max" "nixos" ];

    environment.systemPackages = with pkgs; [
      podman-compose
      docker-compose
    ];
  };
}
