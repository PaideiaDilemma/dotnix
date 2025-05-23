{
  config,
  lib,
  ...
}:
# networking configuration
with lib; let
  cfg = config.host;
in {
  options.host.resolved = {
    # Mainly used to disable this config for wsl
    enable = mkOption {
      default = true;
      description = "Whether to use the networking configuration";
      type = types.bool;
    };
  };

  config = {
    networking = {
      firewall = {
        allowedUDPPorts = [
          5353 # spotify
          22000 # syncthing
        ];

        allowedTCPPorts = [
          9009 # croc
          57621 # spotify
          22000 # syncthing
          8384 # syncthing gui
          9777 # nix-serve
        ];

        allowedTCPPortRanges = [
          {
            from = 1714;
            to = 1764;
          } # KDE Connect
        ];

        allowedUDPPortRanges = [
          {
            from = 1714;
            to = 1764;
          } # KDE Connect
        ];
      };

      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
        wifi.powersave = true;
      };

      nameservers = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
    };
    programs.nm-applet.enable = true;
    services = {
      # network discovery, mDNS
      avahi = {
        enable = false;
        nssmdns4 = true;
        publish = {
          enable = true;
          domain = true;
          userServices = true;
        };
      };

      # DNS resolver
      resolved = mkIf cfg.resolved.enable {
        enable = mkDefault true;
        dnssec = "true";
        domains = ["~."]; # This deactivates the DNS that comes via DHCP apparently
        fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
        dnsovertls = "opportunistic";
      };
    };

    # Don't wait for network startup
    systemd.services.NetworkManager-wait-online.enable = lib.mkForce true;
  };
}
