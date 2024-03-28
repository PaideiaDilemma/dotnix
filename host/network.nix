{
  config,
  lib,
  ...
}:
# networking configuration
{
  networking = {
    firewall = {
      allowedUDPPorts = [
        5353 # spotify
      ];

      allowedTCPPorts = [
        9009 # croc
        57621 # spotify
      ];

      allowedTCPPortRanges = [
        { from = 1714; to = 1764; } # KDE Connect
      ];

      allowedUDPPortRanges = [
        { from = 1714; to = 1764; } # KDE Connect
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
    resolved = {
      enable = true;
      dnssec = "true";
      domains = ["~."]; # This deactivates the DNS that comes via DHCP apparently
      fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
      dnsovertls = "true";
    };
  };

  # Don't wait for network startup
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce true;
}
