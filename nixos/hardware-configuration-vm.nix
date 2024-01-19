# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "ohci_pci"
    "ehci_pci"
    "ahci"
    "sd_mod"
    "sr_mod"
    "aesni_intel"
    "cryptd"
  ];

  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."ROOT".device = "/dev/disk/by-uuid/54cb454d-0b13-496f-9833-de5a4fc6c1b0";

  fileSystems."/" =
    {
      device = "/dev/mapper/ROOT";
      fsType = "btrfs";
      options = [
        "defaults"
        "noatime"
        "nodiratime"
        "compress=zstd:3"
        "ssd"
        "space_cache=v2"
        "subvol=@"
      ];
      label = "NIXOS";
    };

  fileSystems."/home" =
    {
      device = "/dev/mapper/ROOT";
      fsType = "btrfs";
      options = [
        "defaults"
        "noatime"
        "nodiratime"
        "compress=zstd:3"
        "ssd"
        "space_cache=v2"
        "subvol=@home"
      ];
      label = "HOME";
    };

  fileSystems."/nix" =
    {
      device = "/dev/mapper/ROOT";
      fsType = "btrfs";
      options = [
        "defaults"
        "noatime"
        "nodiratime"
        "compress=zstd:3"
        "ssd"
        "space_cache=v2"
        "subvol=@nix"
      ];
      label = "NIX";
    };

  fileSystems."/btrfs" =
    {
      device = "/dev/mapper/ROOT";
      fsType = "btrfs";
      options = [
        "defaults"
        "noatime"
        "nodiratime"
        "compress=zstd:3"
        "ssd"
        "space_cache=v2"
        "subvol=/"
      ];
      label = "BTRFS";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/E76B-2C08";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
      label = "BOOT";
    };

  swapDevices = [
    {
      device = "/btrfs/@swap/swapfile";
    }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    driSupport = true;
  };
}
