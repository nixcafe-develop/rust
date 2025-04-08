{
  pkgs,
  ...
}:
let
  toolchain = pkgs.rustPlatform;
  toml = fromTOML (builtins.readFile ../../../Cargo.toml);
in
# Executed by `nix build`
toolchain.buildRustPackage {
  pname = toml.package.name or "example";
  version = toml.package.version or "1.0.0";
  src = ../../../.;
  cargoLock.lockFile = ../../../Cargo.lock;

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    openssl
  ];

  # For other makeRustPlatform features see:
  # https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/rust.section.md#cargo-features-cargo-features
}
