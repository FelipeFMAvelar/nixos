{ pkgs, ... }:

{
  home.username = "felipe";
  home.homeDirectory = "/home/felipe";
  home.stateVersion = "26.05";

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs.bash = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "FelipeFMAvelar";
      email = "felipefmavelar@gmail.com";
    };
  };

  home.packages = with pkgs; [
    power-profiles-daemon
    opencode
    mcp-nixos
    wl-clipboard
    swaynotificationcenter
    hyprlauncher
    hyprlock
    brave
    microsoft-edge
    vscode
    vesktop
    proton-vpn
    nautilus
    prismlauncher
    antigravity
    bibata-cursors
    papirus-icon-theme
    bitwarden-desktop
    hyprpaper
    btop
    psmisc
    obs-studio
    qbittorrent
    vlc
    xrandr
    xeyes
    fastfetch
    grim
    slurp
    imv
    lmstudio
    xdg-desktop-portal-gtk
  ];

  programs.helix = {
    enable = true;
    settings = {
      theme = "adwaita-dark";
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
    };
    font = {
      name = "Maple Mono Normal NF CN";
      size = 11;
    };
  };

  # Libadwaita / modern GNOME dark theme preference
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      font-name = "Maple Mono Normal NF CN 11";
      monospace-font-name = "Maple Mono Normal NF CN 11";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "adwaita-dark";
  };

  gtk = {
    enable = true;
    font = {
      name = "Maple Mono Normal NF CN";
      size = 11;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      size = 16;
      package = pkgs.bibata-cursors;
    };
  };

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    splash = false
    wallpaper {
        monitor =
        path = /home/felipe/Pictures/Wallpapers/wallhaven-vqwlwl.jpg
        fit_mode = cover
    }
  '';

  xdg.configFile."hypr/hyprlock.conf".text = ''
    general {
      hide_cursor = true
      ignore_empty_input = true
    }

    background {
      monitor =
      path = screenshot
      blur_passes = 2
      blur_size = 6
    }

    input-field {
      monitor =
      size = 250, 50
      position = 0, -80
      dots_center = true
      fade_on_empty = false
      font_color = rgb(255, 255, 255)
      inner_color = rgb(255, 255, 255)
      outer_color = rgb(255, 255, 255)
      placeholder_text = <i><span foreground="##cccccc">Password</span></i>
    }

    label {
      monitor =
      text = cmd[update:1000] echo "$(date +"%H:%M")"
      font_size = 120
      position = 0, 120
      halign = center
      valign = center
    }
  '';

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      modules-left = [ "hyprland/workspaces" ];
      modules-right = [
        "network"
        "pulseaudio"
        "battery"
        "clock"
        "tray"
      ];
      clock = {
        format = "{:%I:%M %p}";
      };
      network = {
        format-wifi = "{icon} {essid}";
        format-ethernet = "󰈀 {ifname}";
        format-disconnected = "󰤭 disconnected";
        format-icons = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        tooltip-format = "{essid} • {ipaddr}";
      };
      battery = {
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-plugged = "󰂇 {capacity}%";
        format-icons = [
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
        interval = 30;
      };
      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟 muted";
        format-icons = {
          default = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
          muted = "󰝟";
        };
      };
    };
    style = ''
      * { font-family: "Maple Mono Normal NF CN"; font-size: 13px; min-height: 0; }
      window#waybar { background: transparent; color: #ffffff; }
      #workspaces button { padding: 0 6px; color: #888888; }
      #workspaces button.active { color: #ffffff; background: #555555; }
      #clock, #battery, #network, #pulseaudio, #tray { padding: 0 10px; }
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    settings = {
      "$mainMod" = "SUPER";

      env = [
        "HYPRCURSOR_THEME,Bibata-Modern-Classic"
        "HYPRCURSOR_SIZE,16"
        "XCURSOR_THEME,Bibata-Modern-Classic"
        "XCURSOR_SIZE,16"
        "WLR_RENDERER,vulkan"
      ];

      monitor = [
        "eDP-1, 2560x1600@240, 0x0, 1.6"
        "HDMI-A-1, 1920x1080@239.76, 1600x0, 1"
      ];

      workspace = [
        "1, monitor:eDP-1"
        "2, monitor:HDMI-A-1"
      ];

      exec-once = [
        "swaync"
        "hyprpaper"
        "waybar"
        "hyprlauncher"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "intl";
        follow_mouse = 1;
        accel_profile = "flat";
        touchpad = {
          natural_scroll = true;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
      };

      decoration = {
        rounding = 10;
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOut, 0.05, 0.9, 0.1, 1.05"
          "easeInOut, 0.05, 0.9, 0.1, 1.1"
          "easeIn, 0.7, 0, 0.84, 0"
        ];
        animation = [
          "windows, 1, 2, easeOut"
          "windowsOut, 1, 2, easeIn"
          "border, 1, 5, easeOut"
          "fade, 1, 5, easeOut"
          "workspaces, 1, 3, easeOut"
        ];
      };

      misc = {
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
      };

      bind = [
        "$mainMod, Return, exec, kitty"
        "$mainMod, Q, killactive"
        "$mainMod, M, exit"
        "$mainMod, W, exec, brave"
        "$mainMod, E, exec, nautilus"
        "$mainMod, V, togglefloating"
        "$mainMod, S, exec, mkdir -p ~/Pictures/Screenshots && grim -g \"$(slurp)\" - | tee ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | wl-copy"
        "$mainMod, D, exec, hyprlauncher"
        "$mainMod, F, fullscreen"
        "$mainMod, L, exec, hyprlock"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}
