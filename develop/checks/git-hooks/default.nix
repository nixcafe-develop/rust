{
  inputs,
  system,
  pkgs,
  ...
}:
let
  package = inputs.self.packages.${system}.default;
in
inputs.git-hooks.lib.${system}.run {
  src = ../../../.;
  settings = {
    rust = {
      check.cargoDeps = pkgs.rustPlatform.importCargoLock {
        lockFile = ../../../Cargo.lock;
      };
    };
  };
  hooks = {
    nixfmt.enable = true;
    deadnix.enable = true;
    statix.enable = true;
    cargo-check = {
      enable = true;
      extraPackages = package.buildInputs ++ package.nativeBuildInputs;
    };
    clippy.enable = true;
    rustfmt.enable = true;
  };
}
