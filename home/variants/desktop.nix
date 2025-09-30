{...}: {
  hyprhome = {
    gui = {
      enable = true;
      primaryMonitor = "DP-3";
      staticMonitors = {
        "DP-3" = {
          resolution = "1920x1080@144.00";
          position = "0x1024";
          initalWorkspace = "1";
        };
        "DP-2" = {
          resolution = "1440x900@59.88700";
          position = "1920x1024";
          initalWorkspace = "10";
          transform = "3";
        };
        "DP-1" = {
          resolution = "1280x1024@75.025";
          position = "1280x0";
          initalWorkspace = "100";
        };
      };
    };
    foot.fontSize = 13;
    waybar.output = "DP-3";
    hyprland = {
      enable = true;
    };
  };
}
