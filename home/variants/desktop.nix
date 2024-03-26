{ ... }:
{
  hyprhome = {
    gui = {
      enable = true;
      primaryMonitor = "DP-3";
      monitors = {
        "DP-3" = {
          resolution = "1920x1080@144";
          position = "1920x597";
          scale = "1";
          initalWorkspace = "1";
        };
        "HDMI-A-1" = {
          resolution = "1920x1080@60";
          position = "0x1024";
          scale = "1";
          initalWorkspace = "10";
        };
        "DP-2" = {
          resolution = "1280x1024@75.025";
          position = "640x0";
          scale = "1";
          initalWorkspace = "100";
        };
      };
    };
    ollama.enable = true;
    way-displays.enable = false; # Static displays, see above
    foot.fontSize = 13;
    waybar.output = "DP-3";
    hyprland = {
      enable = true;
    };
  };
}
