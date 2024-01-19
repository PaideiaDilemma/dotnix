{ config, pkgs, user, ... }:

{
  virtualisation = {
    #docker.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  users.groups.docker.members = [ "max" ];

  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
