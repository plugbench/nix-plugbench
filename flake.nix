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
              kakoune-pluggo
              plumber-pluggo;
        };
        checks = {
          test = pkgs.runCommand "nix-plugbench-test" {} ''
            mkdir -p $out
            : ${pkgs.plumber-pluggo}
          '';
        };
    })) // {
      overlays.default = plugbenchOverlay;
    };
}
