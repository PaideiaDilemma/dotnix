{ inputs, config, pkgs, ... }:
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

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.dbus.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "de";
    libinput.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;


  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    lowLatency.enable = true;
  };

  security.rtkit.enable = true;
}
