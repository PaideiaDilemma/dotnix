{ pkgs,... }:
{
  hyprhome = {
    gui.enable = true;
    waybar.battery.enable = true;
    wezterm.enable = false;
    waybar.output = "eDP-1";
    hyprland = {
      enable = true;
      enableAnimations = true;
      monitors = {
        "eDP-1" = {
          resolution = "1920x1080";
          position = "auto";
          scale = "1";
          initalWorkspace = "1";
        };
      };
      extraConfig = ''
        gestures {
          workspace_swipe=1
          workspace_swipe_distance=250
          workspace_swipe_cancel_ratio=0.3
          workspace_swipe_create_new=1
        }

        device:AT Translated Set 2 keyboard {
          sensitivity=0.8
          kb_layout=de
        }

        general {
          resize_on_border=1
        }

        # KEY BINDINGS
        #bindl=,switch:[Lid Switch],exec,systemctl suspend
        binde=,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
        bindl=,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        bindl=,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        bindr=,XF86MonBrightnessDown, exec, brightnessctl set 5%-
        bindr=,XF86MonBrightnessUp, exec, brightnessctl set 5%+
      '';
    };
  };
}
