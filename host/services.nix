{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.host;
in {
  options.host = {
    openssh.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Wheather to enable the openssh service";
    };
  };

  config = {
    # Enable the OpenSSH daemon.
    services.openssh.enable = cfg.openssh.enable;

    services.dbus.enable = true;

    # Enable the X11 windowing system.
    services.xserver = {
      enable = cfg.gui.enable;
      xkb.layout = "us";
    };

    services.libinput.enable = true;

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

    programs.wireshark.enable = true;
  };
}
