{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.plugbench.kakoune;
in {
  options.plugbench.kakoune.enable = mkEnableOption "plugbench kakoune";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.kakoune-pluggo ];

    nixpkgs.overlays = [
      (final: prev: let
         pluggo-init = prev.stdenv.mkDerivation {
           name = "kakoune-pluggo-init";
           dontUnpack = true;
           installPhase = ''
             runHook preInstall

             target="$out/share/kak/autoload/plugins"
             mkdir -p "$target"
             # Quoted delimiter: the token may be a $(cat ...) that has to
             # survive to kak start-up rather than run here in the sandbox.
             cat <<'EOF' >"$target/kakoune-pluggo-init.kak"
             evaluate-commands %sh{${config.plugbench.tokenPrefix} ${final.kakoune-pluggo}/bin/kakoune-pluggo start-session}
             EOF

             runHook postInstall
           '';
         };
       in {
         kakoune = prev.kakoune.overrideAttrs (finalAttrs: prevAttrs: {
           paths = prevAttrs.paths ++ [ pluggo-init ];
         });
       })
    ];
  };

}
