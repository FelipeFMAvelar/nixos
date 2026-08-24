{
  pkgs,
  lib,
  llm-agents,
  playit-nixos-module,
  ...
}: let
  kvlibadwaita = pkgs.stdenvNoCC.mkDerivation {
    pname = "kvlibadwaita";
    version = "1f4e0bec44b13dabfa1fe4047aa8eeaccf2f3557";
    src = pkgs.fetchFromGitHub {
      owner = "GabePoel";
      repo = "KvLibadwaita";
      rev = "1f4e0bec44b13dabfa1fe4047aa8eeaccf2f3557";
      hash = "sha256-jCXME6mpqqWd7gWReT04a//2O83VQcOaqIIXa+Frntc=";
    };
    installPhase = ''
      mkdir -p $out/share/Kvantum
      cp -r src/KvLibadwaita $out/share/Kvantum/
    '';
  };
in {
  home.username = "felipe";
  home.homeDirectory = "/home/felipe";
  home.stateVersion = "26.05";

  home.sessionPath = ["$HOME/.local/bin"];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [
      "erasedups"
      "ignoredups"
    ];
    historyIgnore = [
      "ls"
      "cd"
      "exit"
      "clear"
    ];
    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
    ];
    shellAliases = {
      felipao = "ssh felipe@134.65.28.106";
      avavelar = "ssh felipe@193.123.103.104";
    };
    initExtra = ''
      __prompt_path() {
        if [[ "$PWD" == "$HOME" ]]; then
          printf ""
        else
          pwd | sed "s|^$HOME|~|"
        fi
      }
      __prompt_git() {
        local b
        b=$(git branch --show-current 2>/dev/null) || return
        [[ -n "$b" ]] && printf "  %s" "$b"
      }
      PS1='\[\e[38;5;75m\] \[\e[38;5;252m\]$(__prompt_path)\[\e[38;5;245m\]$(__prompt_git) \[\e[38;5;75m\]❯ \[\e[0m\]'
    '';
  };

  programs.readline = {
    enable = true;
    variables = {
      completion-ignore-case = true;
      completion-map-case = true;
      show-all-if-ambiguous = true;
      colored-stats = true;
      visible-stats = true;
      mark-symlinked-directories = true;
    };
  };

  programs.eza = {
    enable = true;
    icons = "always";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.codex = {
    enable = true;
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "FelipeFMAvelar";
      email = "felipefmavelar@gmail.com";
    };
  };

  home.packages = with pkgs; [
    (llama-cpp.override {cudaSupport = true;})
    power-profiles-daemon
    playit-nixos-module.packages.${pkgs.system}.playit
    llm-agents.packages.${pkgs.system}.opencode
    mcp-nixos
    wl-clipboard
    swaynotificationcenter
    hyprlauncher
    hyprlock
    brave
    microsoft-edge
    vscode
    ((vesktop.override {electron_43 = electron_42;}).overrideAttrs (old: {
      preBuild = ''
        cp -r ${electron_42.dist} electron-dist
        chmod -R u+w electron-dist
      '';
    }))
    proton-vpn
    nautilus
    prismlauncher
    antigravity-cli
    bibata-cursors
    papirus-icon-theme
    bitwarden-desktop
    hyprpaper
    pavucontrol
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
    screen
    element-desktop
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
      window_padding_width = 10;
      cursor_trail = 3;
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = 2;
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
    platformTheme.name = "adwaita";
    style.name = "kvantum";
  };

  qt.kvantum = {
    enable = true;
    themes = [kvlibadwaita];
    settings.General.theme = "KvLibadwaitaDark";
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    font = {
      name = "Maple Mono Normal NF CN";
      size = 11;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-theme-name = "adw-gtk3-dark";
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

  xdg.configFile."hypr/hyprtoolkit.conf".text = ''
    accent = 0xFFFFFFFF
    accent_secondary = 0xFFFFFFFF
    rounding_large = 0
    rounding_small = 0
  '';

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.gnome.Nautilus.desktop";
      "x-scheme-handler/mailto" = "brave-browser.desktop";
      "x-scheme-handler/discord" = "vesktop.desktop";
      "image/png" = "imv.desktop";
    };
    associations.added = {
      "image/png" = "imv.desktop";
    };
  };

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      modules-left = ["hyprland/workspaces"];
      modules-center = ["clock"];
      modules-right = [
        "tray"
        "network"
        "pulseaudio"
        "battery"
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
        on-click = "pavucontrol";
      };
    };
    style = ''
      * { font-family: "Maple Mono Normal NF CN"; font-size: 13px; min-height: 0; border-radius: 0; }
      window#waybar { background: transparent; color: #ffffff; border-radius: 0; }
      #workspaces button { padding: 0 6px; color: #888888; border-radius: 0; }
      #workspaces button.active { color: #000000; background: #ffffff; border-radius: 0; }
      #clock, #battery, #network, #pulseaudio, #tray { padding: 0 10px; border-radius: 0; }
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    settings = {
      mainMod = {
        _var = "SUPER";
      };

      config = {
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
        };
        decoration = {
          rounding = 0;
        };
        input = {
          kb_layout = "us";
          kb_variant = "intl";
          follow_mouse = 1;
          accel_profile = "flat";
          touchpad = {
            natural_scroll = true;
            scroll_factor = 0.5;
          };
        };
        animations = {
          enabled = true;
        };
        misc = {
          disable_splash_rendering = true;
          disable_hyprland_logo = true;
          force_default_wallpaper = 0;
        };
      };

      curve = [
        {
          _args = [
            "easeOut"
            {
              type = "bezier";
              points = [
                [
                  0.05
                  0.9
                ]
                [
                  0.1
                  1.05
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "easeInOut"
            {
              type = "bezier";
              points = [
                [
                  0.05
                  0.9
                ]
                [
                  0.1
                  1.1
                ]
              ];
            }
          ];
        }
        {
          _args = [
            "easeIn"
            {
              type = "bezier";
              points = [
                [
                  0.7
                  0
                ]
                [
                  0.84
                  0
                ]
              ];
            }
          ];
        }
      ];

      animation = [
        {
          leaf = "windows";
          enabled = true;
          speed = 2;
          bezier = "easeOut";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 2;
          bezier = "easeIn";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 5;
          bezier = "easeOut";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 5;
          bezier = "easeOut";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 3;
          bezier = "easeOut";
        }
      ];

      env = [
        {
          _args = [
            "HYPRCURSOR_THEME"
            "Bibata-Modern-Classic"
          ];
        }
        {
          _args = [
            "HYPRCURSOR_SIZE"
            "16"
          ];
        }
        {
          _args = [
            "XCURSOR_THEME"
            "Bibata-Modern-Classic"
          ];
        }
        {
          _args = [
            "XCURSOR_SIZE"
            "16"
          ];
        }
        {
          _args = [
            "WLR_RENDERER"
            "vulkan"
          ];
        }
      ];

      monitor = [
        {
          output = "eDP-1";
          mode = "2560x1600@240";
          position = "0x0";
          scale = 1.6;
        }
        {
          output = "HDMI-A-1";
          mode = "1920x1080@239.76";
          position = "1600x0";
          scale = 1;
        }
      ];

      workspace_rule = [
        {
          workspace = "1";
          monitor = "eDP-1";
        }
        {
          workspace = "2";
          monitor = "HDMI-A-1";
        }
      ];

      on = {
        _args = [
          "hyprland.start"
          (lib.generators.mkLuaInline ''
            function()
              hl.exec_cmd("swaync")
              hl.exec_cmd("hyprpaper")
              hl.exec_cmd("waybar")
              hl.exec_cmd("hyprlauncher")
            end
          '')
        ];
      };

      bind = [
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + Return"'')
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("kitty")'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + Q"'')
            (lib.generators.mkLuaInline "hl.dsp.window.close()")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + M"'')
            (lib.generators.mkLuaInline "hl.dsp.exit()")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + W"'')
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("brave")'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + E"'')
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("nautilus")'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + space"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + S"'')
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd('mkdir -p ~/Pictures/Screenshots && grim -g "$(slurp)" - | tee ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | wl-copy')'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + D"'')
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("hyprlauncher")'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + F"'')
            (lib.generators.mkLuaInline "hl.dsp.window.fullscreen()")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + L"'')
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("hyprlock")'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + left"'')
            (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "left" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + right"'')
            (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "right" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + up"'')
            (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "up" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + down"'')
            (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "down" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + left"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "left" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + right"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "right" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + up"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "up" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + down"'')
            (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "down" })'')
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 1"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 1 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 2"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 2 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 3"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 3 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 4"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 4 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 5"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 5 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 6"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 6 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 7"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 7 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 8"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 8 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 9"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 9 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + 0"'')
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 10 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 1"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 1 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 2"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 2 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 3"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 3 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 4"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 4 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 5"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 5 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 6"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 6 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 7"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 7 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 8"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 8 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 9"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 9 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 0"'')
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 10 })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + mouse:272"'')
            (lib.generators.mkLuaInline "hl.dsp.window.drag()")
            {mouse = true;}
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline ''mainMod .. " + mouse:273"'')
            (lib.generators.mkLuaInline "hl.dsp.window.resize()")
            {mouse = true;}
          ];
        }
      ];
    };
  };
}
