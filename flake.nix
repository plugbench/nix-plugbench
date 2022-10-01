{
  description = "TODO: fill me in";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nix-plugbench = pkgs.callPackage ./derivation.nix {};
      in {
        packages = {
          default = nix-plugbench;
          inherit nix-plugbench;
        };
        checks = {
          test = pkgs.runCommandNoCC "nix-plugbench-test" {} ''
            mkdir -p $out
            : ${nix-plugbench}
          '';
        };
    })) // {
      overlays.default = final: prev: {
        nix-plugbench = prev.callPackage ./derivation.nix {};
      };
    };
}
