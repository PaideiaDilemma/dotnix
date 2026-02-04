{pkgs, lib, ...}: 
{
    # We disable this and add service + dbus manually cause otherwise
    # fprint get's enabled for all pam module :((
    services.fprintd.enable = false;
    systemd.packages = [ pkgs.fprintd-goodix ];
    environment.systemPackages = [ pkgs.fprintd-goodix ];
    services.dbus.packages = [ pkgs.fprintd-goodix ];
}
