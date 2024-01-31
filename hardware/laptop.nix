# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ inputs, config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    # This is a dell latitude 3410, which is very similar to an xps 13 7390
    inputs.nixos-hardware.nixosModules.dell-xps-13-7390
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "cryptd" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "iwlwifi" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."ROOT".device = "/dev/disk/by-uuid/40ee0571-1559-4139-adfd-460558a12a0f";

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
      device = "/dev/disk/by-uuid/BC2A-4F76";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
      label = "BOOT";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
