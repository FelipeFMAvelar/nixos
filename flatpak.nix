# Declaratively manages Flatpak packages via nix-flatpak (system-wide, Flathub).
# Add/remove app IDs from `packages` and `nixos-rebuild switch` to apply.
{ ... }:

{
  services.flatpak = {
    enable = true;
    packages = [
      "com.usebottles.bottles"
      "org.vinegarhq.Sober"
    ];
  };
}