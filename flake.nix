{
  description = "Derivations and modules for installing plugbench with Nix.";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    clipboard-pluggo.url = "github:plugbench/clipboard-pluggo";
    clipboard-pluggo.inputs.nixpkgs.follows = "nixpkgs";

    kakoune-pluggo.url = "github:plugbench/kakoune-pluggo";
    kakoune-pluggo.inputs.nixpkgs.follows = "nixpkgs";

    plumber-pluggo.url = "github:plugbench/plumber-pluggo";
    plumber-pluggo.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, flake-utils, clipboard-pluggo, kakoune-pluggo, plumber-pluggo }: let
    plugbenchOverlay = final: prev:
      clipboard-pluggo.overlays.default final prev //
      kakoune-pluggo.overlays.default final prev //
      plumber-pluggo.overlays.default final prev;
  in
    (flake-utils.lib.eachDefaultSystem (system: {
      packages = clipboard-pluggo.packages.${system} //
                 kakoune-pluggo.packages.${system} //
                 plumber-pluggo.packages.${system};
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
