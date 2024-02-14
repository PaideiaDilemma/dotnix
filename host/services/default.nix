{ inputs, config, lib,  pkgs, ... }:
with lib;
let
  cfg = config.host;
in
{
  options.host = {
    loginToShell = mkOption {
      type = types.bool;
      default = !cfg.gui.enable;
      description = "Wheather to login to the shell or ";
    };

    openssh.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Wheather to enable the openssh service";
    };
  };

  config = {
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
        hyprland_session = {
          user = "max";
          command = "$SHELL -l ${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/Hyprland";
        };
        initial_session = {
          user = "max";
          command = "$SHELL -l";
        };
        default_session = if cfg.loginToShell then initial_session else hyprland_session;
      };
    };

    # Enable the OpenSSH daemon.
    services.openssh.enable = cfg.openssh.enable;

    services.dbus.enable = true;

    # Enable the X11 windowing system.
    services.xserver = {
      enable = cfg.gui.enable;
      layout = "de";
      libinput.enable = true;
    };

    # Enable CUPS to print documents.
    services.printing.enable = cfg.gui.enable;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    services.udisks2.enable = cfg.gui.enable;

    services.blueman.enable = true;

    security.rtkit.enable = true;
  };
}
