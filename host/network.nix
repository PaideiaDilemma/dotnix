{
  config,
  lib,
  pkgs,
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
          22000 # syncthing
        ];

        allowedTCPPorts = [
          1400 # noson
          9009 # croc
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
        nssmdns4 = true;
        publish = {
          enable = true;
          domain = true;
          userServices = true;
        };
      };

      # DNS resolver
      resolved = mkIf cfg.resolved.enable {
        enable = mkDefault false;
        dnssec = "true";
        domains = ["~."]; # This deactivates the DNS that comes via DHCP apparently
        fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
        dnsovertls = "opportunistic";
      };
    };
    # TODO: make this optional
    # support SSDP https://serverfault.com/a/911286/9166
    networking.firewall.extraPackages = [ pkgs.ipset ];
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
