{ config, pkgs, user, ... }:

{
  virtualisation = {
    docker.enable = true;
    podman = {
      enable = true;
      #dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    libvirtd.enable = true;
  };

  users.groups.docker.members = [ "max" ];
  users.groups.libvirtd.members = [ "max" ];

  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
