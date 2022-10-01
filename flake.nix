{
  description = "Derivations and modules for installing plugbench with Nix.";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = {
        };
        checks = {
          test = pkgs.runCommand "nix-plugbench-test" {} ''
            mkdir -p $out
            :
          '';
        };
    })) // {
      overlays.default = final: prev: {
      };
    };
}
