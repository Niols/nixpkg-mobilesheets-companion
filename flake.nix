{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    erosanix.url = "github:emmanuelrosa/erosanix";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem = {system, pkgs, self', inputs', ...}: {
        packages.default = pkgs.callPackage ./mobilesheets-companion.nix {
          inherit (inputs'.erosanix.lib) mkWindowsApp makeDesktopIcon copyDesktopIcons;
        };

        apps.default = {
          type = "app";
          program = "${self'.packages.default}/bin/mobilesheets-companion";
        };
      };

      perInput = system: flake:
        if flake ? lib.${system} then { lib = flake.lib.${system}; } else { };
    };
}
