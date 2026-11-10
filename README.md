# Rust development template

Nix flake template for Rust projects. The development shell provides `cargo`, `rustc`, `clippy`, `rustfmt`, and `pkg-config`. The flake builds the crate with `buildRustPackage` and `Cargo.lock`, and enables pre-commit hooks for Nix and Rust files. It is built with [purr](https://flakehub.com/f/nixcafe/purr) and [git-hooks.nix](https://flakehub.com/f/cachix/git-hooks.nix).

This repository is part of the [develop-templates](https://github.com/nixcafe/develop-templates) collection.

## Quick start

Create a project from the template:

```bash
nix flake init -t "github:nixcafe/develop-templates#rust" --refresh
```

To use a shorter registry name:

```bash
nix registry add beans "github:nixcafe/develop-templates"
nix flake init -t beans#rust
```

If you use [cattery-modules](https://github.com/nixcafe/cattery-modules), the `beans` registry entry already exists.

You can also create a GitHub repository from this template:

```bash
gh repo create my-rust-project --template nixcafe-develop/rust --clone
```

Enter the development shell:

```bash
direnv allow
cargo build
```

## What's included

| Item | Purpose |
|------|---------|
| `cargo`, `rustc` | Toolchain from `pkgs.rustPlatform` |
| `clippy` | Rust linter |
| `rustfmt` | Rust formatter |
| `pkg-config` | Build dependency discovery |
| `RUST_SRC_PATH` | Standard library sources for `rust-analyzer` |

`RUST_SRC_PATH` points to `toolchain.rustLibSrc`.

## Customization

### Change the Rust toolchain

The shell and the package build use `pkgs.rustPlatform` from the nixpkgs input. To use a different toolchain, replace the `toolchain` binding in `develop/shells/default/default.nix` and `develop/packages/default/default.nix` with another `rustPlatform`.

### Add build inputs

The package build uses `pkg-config` as a native build input and `openssl` as a build input. Add other libraries to `nativeBuildInputs` or `buildInputs` in `develop/packages/default/default.nix`.

### Pre-commit hooks

`develop/checks/git-hooks/default.nix` enables six hooks:

| Hook | What it checks |
|------|----------------|
| `nixfmt` | Nix file formatting |
| `deadnix` | Dead code in Nix files |
| `statix` | Nix anti-patterns |
| `cargo-check` | Type-checks the crate |
| `clippy` | Rust lint warnings |
| `rustfmt` | Rust code formatting |

The `cargo-check` hook runs with the package's `buildInputs` and `nativeBuildInputs`, so `openssl` and `pkg-config` are available during the check.

### Dependencies

Dependency versions are recorded in `Cargo.lock`. The package build reads the lock file directly:

```nix
cargoLock.lockFile = ../../../Cargo.lock;
```

Run `cargo update` to update the lock file, then rebuild with `nix build`.

## Project structure

```
.
├── flake.nix                          # flake entrypoint
├── Cargo.toml                         # package manifest
├── Cargo.lock                         # dependency lock file
├── .envrc                             # direnv integration (use flake)
├── .gitignore
├── src/
│   └── main.rs                        # crate entry point
└── develop/
    ├── packages/default/default.nix   # buildRustPackage derivation
    ├── shells/default/default.nix     # development shell
    └── checks/git-hooks/default.nix   # pre-commit hooks
```

## Useful commands

```bash
direnv allow        # load the development shell
nix develop         # load the shell without direnv
cargo build         # build the crate
nix build           # build the default package
nix flake check     # run the flake checks, including the git hooks
```
