{ lib, config, pkgs, ... }:
let
  # Wallpaper configuration with fetchurl to download and hash the wallpaper
  wallpaperPath = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/lunik1/nixos-logo-gruvbox-wallpaper/master/png/gruvbox-light-rainbow.png";
    sha256 = "cfaf892e6b4093789cc36f29b0c026a181fdc10e9f224aa8fccf298c1d3a0357";
  };

  # Local path to store the wallpaper in the user's home directory
  localWallpaperPath = "${config.xdg.dataHome}/wallpapers/gruvbox-light-rainbow.png";
in
{
  home.homeDirectory = "/Users/crackz";
 
  # Ensure the wallpaper directory exists and link the wallpaper
  home.file."${localWallpaperPath}".source = wallpaperPath;

  # Activation script to set the wallpaper using AppleScript
  home.activation.setWallpaper = lib.mkAfter ''
    /usr/bin/osascript -e 'tell application "Finder" to set desktop picture to POSIX file "${localWallpaperPath}"'
  '';

 # make gui apps searchable by spotlight
  home.activation = {
    rsync-home-manager-applications = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      rsyncArgs="--archive --checksum --chmod=-w --copy-unsafe-links --delete"
      apps_source="$genProfilePath/home-path/Applications"
      moniker="Home Manager Trampolines"
      app_target_base="${config.home.homeDirectory}/Applications"
      app_target="$app_target_base/$moniker"
      mkdir -p "$app_target"
      ${pkgs.rsync}/bin/rsync $rsyncArgs "$apps_source/" "$app_target"
    '';
  };
}
