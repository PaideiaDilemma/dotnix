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
    flatpak.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Wheather to enable the flatpak service";
    };
  };

  config = {
    services.openssh.enable = cfg.openssh.enable;

    services.flatpak.enable = cfg.flatpak.enable;

    services.dbus.enable = true;

    services.nscd.enable = true;
    services.nscd.enableNsncd = true;

    services.xserver = {
      enable = cfg.gui.enable;
      xkb.layout = "us";
    };

    services.libinput.enable = true;

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
