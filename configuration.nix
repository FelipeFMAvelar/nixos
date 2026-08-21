# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  # Configure console keymap
  console.keyMap = "us-acentos";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."felipe" = {
    isNormalUser = true;
    description = "Felipe F. M. Avelar";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];

    packages = with pkgs; [ ];
  };

  # Allow passwordless sudo for users in the wheel group.
  security.sudo.wheelNeedsPassword = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the Flakes and nix-command experimental features.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # NVIDIA open kernel modules (recommended by NVIDIA for modern cards).
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    open = true; # use nvidia-open, the recommended open kernel modules
    modesetting.enable = true; # required for Wayland
    nvidiaSettings = true;
    dynamicBoost.enable = true;
  };

  # Hyprland (Wayland compositor).
  programs.hyprland.enable = true;

  # Steam (with proper system integration).
  programs.steam.enable = true;

  # Docker daemon.
  virtualisation.docker.enable = true;

  # GVFS for file management (Nautilus, desktop trash, etc.).
  services.gvfs.enable = true;

  services.power-profiles-daemon.enable = true;

  # Cloudflare WARP daemon (warp-svc) for warp-cli.
  services.cloudflare-warp.enable = true;

  systemd.services.set-power-profile = {
    description = "Set power profile to performance";
    wantedBy = [ "graphical.target" ];
    after = [ "power-profiles-daemon.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance";
      RemainAfterExit = true;
    };
  };

  # UPower daemon (battery status for waybar and other tools).
  services.upower.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      common.default = "*";
      hyprland.default = [
        "hyprland"
        "gtk"
      ];
    };
  };

  # Allows running third-party dynamically linked binaries (e.g. agy CLI).
  programs.nix-ld.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix!
    nixfmt
    alejandra
    deadnix
    statix
    nixd
    nil
  ];

  # Fonts: Maple Mono (Normal style, hinted, with ligatures, Nerd Font, CJK).
  fonts.packages = with pkgs; [
    maple-mono.Normal-NF-CN
  ];

  # Use Maple Mono system-wide (Qt and other fontconfig consumers pick it up here).
  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "Maple Mono Normal NF CN" ];
    monospace = [ "Maple Mono Normal NF CN" ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
