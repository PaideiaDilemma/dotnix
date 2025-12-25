{pkgs, ...}: {
  hyprhome = {
    gui = {
      enable = true;
      primaryMonitor = "eDP-1";
    };
    waybar.battery.enable = true;
    waybar.output = "eDP-1";
    hyprland = {
      enable = true;
      enableAnimations = true;
      extraConfig = ''
        gesture = 3, vertical, workspace
        gesture = 3, left, dispatcher, exec, hyprlock --grace 2

        device {
          name = AT Translated Set 2 keyboard
          sensitivity=0.8
          kb_layout=de
        }

        general {
          resize_on_border=1
        }

        # KEY BINDINGS
        bindle=,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
        bindl=,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        bindl=,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        bindl=,XF86MonBrightnessDown, exec, brightnessctl set 5%-
        bindl=,XF86MonBrightnessUp, exec, brightnessctl set 5%+
      '';
    };
  };
}
