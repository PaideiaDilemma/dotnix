{...}: {
  hyprhome = {
    gui = {
      enable = true;
      primaryMonitor = "DP-3";
      staticMonitors = {
        "HDMI-A-1" = {
          resolution = "1920x1080@120.00";
          position = "0x597";
          scale = "1";
          initalWorkspace = "1";
        };
        "DP-3" = {
          resolution = "1920x1080@60";
          position = "1920x1024";
          scale = "1";
          initalWorkspace = "10";
        };
        "DP-2" = {
          resolution = "1280x1024@75.025";
          position = "1920x0";
          scale = "1";
          initalWorkspace = "100";
        };
      };
    };
    foot.fontSize = 13;
    waybar.output = "HDMI-A-1";
    hyprland = {
      enable = true;
    };
  };
}
