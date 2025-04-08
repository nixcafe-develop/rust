{
  inputs,
  system,
  pkgs,
  ...
}:
let
  package = inputs.self.packages.${system}.default;
in
inputs.pre-commit-hooks.lib.${system}.run {
  src = ../../../.;
  settings = {
    rust = {
      check.cargoDeps = pkgs.rustPlatform.importCargoLock {
        lockFile = ../../../Cargo.lock;
      };
    };
  };
  hooks = {
    # formatter
    nixfmt-rfc-style.enable = true;
    deadnix.enable = true;
    statix.enable = true;
    # rust
    cargo-check = {
      enable = true;
      extraPackages = package.buildInputs ++ package.nativeBuildInputs;
    };
    clippy.enable = true;
    rustfmt.enable = true;
  };
}
