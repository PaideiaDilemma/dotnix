{ config, pkgs, ... }:
{
  #Evremap service to fix my keyboard layout..
  #systemd.services.keyboard-remaps = {
  #  description = "Remaps keys with evremap";
  #  serviceConfig.ExecStart = toString (pkgs.writeShellScript "remap" ''
  #    /home/max/Apps/Files/evremap/target/release/evremap remap /home/max/Apps/Files/evremap/de.toml
  #  '');
  #  wantedBy = [ "multi-user.target" ];
  #  serviceConfig.group = "root";
  #};
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        user = "max";
        command = "$SHELL -l ${pkgs.hyprland}/bin/Hyprland";
      };
      default_session = initial_session;
    };
  };

  services.dbus.enable = true;
}
