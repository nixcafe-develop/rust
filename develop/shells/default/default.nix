{
  inputs,
  pkgs,
  mkShell,
  system,
  ...
}:
let
  toolchain = pkgs.rustPlatform;
in
mkShell {
  packages = with pkgs; [
    (with toolchain; [
      cargo
      rustc
      rustLibSrc
    ])
    clippy
    rustfmt
    pkg-config
  ];

  # Specify the rust-src path (many editors rely on this)
  RUST_SRC_PATH = "${toolchain.rustLibSrc}";

  inherit (inputs.self.checks.${system}.pre-commit-check) shellHook;
  buildInputs = inputs.self.checks.${system}.pre-commit-check.enabledPackages;
}
