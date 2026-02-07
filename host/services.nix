{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotnix;
in {
  options.dotnix = {
    openssh.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Wheather to enable the openssh service";
    };
    flatpak.enable = lib.mkOption {
      type = lib.types.bool;
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

    services.fprintd.enable = true;

    security.rtkit.enable = true;

    programs.wireshark.enable = true;
  };
}
