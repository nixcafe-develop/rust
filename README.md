# Nix Flake · Rust Dev Template

> purr · git-hooks · rust · cargo · clippy · nix-flake

Nix flake template for Rust development — batteries-included dev shell, pre-commit guardrails, and reproducible builds via `cargo` + `rustPlatform`. Drop into `direnv`, start hacking.

Part of the [develop-templates](https://github.com/nixcafe/develop-templates) collection (`nix flake init`-ready).

## Quick Start

### `nix flake init`

```bash
nix flake init -t "github:nixcafe/develop-templates#rust" --refresh
```

Register an alias:
```bash
nix registry add beans "github:nixcafe/develop-templates"
nix flake init -t beans#rust
```

> **Tip**: With [cattery-modules](https://github.com/nixcafe/cattery-modules), `beans` is pre-registered.

### Create from Template

```bash
gh repo create my-rust-project --template nixcafe/rust --clone
```

### Enter the Dev Shell

```bash
direnv allow
cargo build
```

## What’s Inside

| Tool | Purpose |
|------|---------|
| `cargo` / `rustc` / `rustLibSrc` | Rust toolchain via `rustPlatform` |
| `clippy` | Rust linter — catches common mistakes |
| `rustfmt` | Rust formatter — consistent code style |
| `pkg-config` | Build dependency discovery |
| `RUST_SRC_PATH` | LSP source path for `rust-analyzer` |

## Customizing

### Change Rust Toolchain

Override `rustPlatform` in `develop/shells/default/default.nix`:

```nix
# pin to a specific nightly
toolchain = pkgs.rust-bin.nightly.latest.default.override {
  extensions = [ "rust-src" ];
};
```

### Pre-commit Hooks

Defined in `develop/checks/git-hooks/default.nix`. Runs on every commit:

| Hook | What it checks |
|------|----------------|
| `nixfmt` | Nix file formatting |
| `deadnix` | Dead code in Nix files |
| `statix` | Nix anti-patterns |
| `cargo-check` | Type-checks the crate |
| `clippy` | Rust lint warnings |
| `rustfmt` | Rust code formatting |

### Pin Dependencies

Dependencies are locked via `Cargo.lock`. Builds are fully reproducible when combined with Nix’s hashed fetchers. The package builder at `develop/packages/default/default.nix` reads lockFile directly:

```nix
cargoLock.lockFile = ../../../Cargo.lock;
```

## Project Structure

```
rust/
├── flake.nix                         # flake entrypoint → purr.mkFlake
├── Cargo.toml                        # package manifest
├── Cargo.lock                        # pinned dep tree
├── src/
│   └── main.rs                       # crate entrypoint
├── develop/
│   ├── packages/default/default.nix  # nix build → buildRustPackage
│   ├── shells/default/default.nix    # nix develop → mkShell
│   └── checks/git-hooks/default.nix  # pre-commit hooks
├── .envrc                            # direnv auto-load
└── .gitignore
```

## Why This Exists

- **Reproducible**: The same lockfile + Nix closure = the same binary every time.
- **Guardrails**: Zero-warning CI won’t let sloppy code through.
- **Editor-ready**: `RUST_SRC_PATH` wired up so `rust-analyzer` resolves stdlib sources out of the box.
- **Offline-capable**: All tooling comes from the `/nix/store` — no network needed after initial fetch.
