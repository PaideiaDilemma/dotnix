{ inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    startMenuLaunchers = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = true;
    wslConf.network.generateHosts = false;
    wslConf.user.default = "nixos";
    defaultUser = "nixos";

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = true;
  };

  host = {
    gui.enable = false;
    openssh.enable = false;
  };
}
