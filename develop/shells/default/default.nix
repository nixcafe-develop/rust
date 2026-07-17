{
  inputs,
  pkgs,
  system,
  ...
}:
let
  toolchain = pkgs.rustPlatform;
in
pkgs.mkShell {
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

  RUST_SRC_PATH = "${toolchain.rustLibSrc}";

  inherit (inputs.self.checks.${system}.git-hooks) shellHook;
  buildInputs = inputs.self.checks.${system}.git-hooks.enabledPackages;
}
