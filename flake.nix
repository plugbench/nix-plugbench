{
  description = "Derivations and modules for installing plugbench with Nix.";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }: let
    plugbenchOverlay = final: prev: let
        pkg = file: overrides: let
            src = prev.fetchFromGitHub (import file);
          in
            prev.callPackage "${src}/derivation.nix" ({ fetchFromGitHub = _: src; } // overrides);
      in {
        clipboard-pluggo = pkg ./pkg/clipboard-pluggo.nix {
          inherit (final.darwin.apple_sdk.frameworks) Cocoa;
          inherit (final.xorg) libX11;
        };
        kakoune-pluggo = pkg ./pkg/kakoune-pluggo.nix {};
        plumber-pluggo = pkg ./pkg/plumber-pluggo.nix {};
      };
  in
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          overlays = [ plugbenchOverlay ];
          inherit system;
        };
      in {
        packages = {
          inherit (pkgs)
              clipboard-pluggo
              kakoune-pluggo
              plumber-pluggo;
        };
        checks = {
          test = pkgs.runCommand "nix-plugbench-test" {} ''
            mkdir -p $out
            : ${pkgs.plumber-pluggo}
            : ${pkgs.kakoune-pluggo}
          '';
        };
    })) // {
      overlays.default = plugbenchOverlay;

      darwinModules = rec {
        plugbench = {
          imports = [
            ./nix-darwin/modules
          ];
          config = {
            nixpkgs.overlays = [ plugbenchOverlay ];
          };
        };
        default = plugbench;
      };

      nixosModules = rec {
        plugbench = {
          config = {
            nixpkgs.overlays = [ plugbenchOverlay ];
          };
        };
        default = plugbench;
      };

    };
}
