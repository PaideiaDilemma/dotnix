{
  config,
  lib,
  pkgs,
  ...
}:
# networking configuration
let
  cfg = config.dotnix;
in {
  options.dotnix.resolved = {
    # Mainly used to disable this config for wsl
    enable = lib.mkOption {
      default = true;
      description = "Whether to use the networking configuration";
      type = lib.types.bool;
    };
  };

  config = {
    networking = {
      firewall = {
        allowedUDPPorts = [
          22000 # syncthing
        ];

        allowedTCPPorts = [
          1400 # noson
          9009 # croc
          22000 # syncthing
          8384 # syncthing gui
          9777 # nix-serve
        ] ++ lib.optionals (cfg.sunshine.enable) [
          47989
          47984
          48010
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
        ] ++ lib.optionals (cfg.sunshine.enable) [
          {
            from = 47998;
            to = 48000;
          }
        ];
      };

      networkmanager = {
        enable = true;
        #dns = "systemd-resolved";
        wifi.powersave = true;
      };

      nameservers = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
    };
    programs.nm-applet.enable = true;
    services = {
      # network discovery, mDNS
      avahi = {
        enable = false;
        nssmdns4 = false;
        publish = {
          enable = true;
          domain = true;
          userServices = true;
        };
      };

      # DNS resolver
      resolved = lib.mkIf cfg.resolved.enable {
        enable = lib.mkDefault false;
        settings = {
          Resolve = {
            domains = ["~."]; # This deactivates the DNS that comes via DHCP apparently
            DNSSEC = "true";
            fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
            DNSOverTLS = "opportunistic";
          };
        };
      };
    };
    # TODO: make this optional
    # support SSDP https://serverfault.com/a/911286/9166
    networking.firewall.extraPackages = [pkgs.ipset];
    networking.firewall.extraCommands = ''
      if ! ipset --quiet list upnp; then
        ipset create upnp hash:ip,port timeout 3
      fi
      iptables -A OUTPUT -d 239.255.255.250/32 -p udp -m udp --dport 1900 -j SET --add-set upnp src,src --exist
      iptables -A nixos-fw -p udp -m set --match-set upnp dst,dst -j nixos-fw-accept
    '';
    # Don't wait for network startup
    systemd.services.NetworkManager-wait-online.enable = lib.mkForce true;
  };
}
