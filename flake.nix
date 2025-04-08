{
  inputs = {
    # nixos-unstable (use flakehub to avoid github api limit)
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

    snowfall-lib = {
      url = "https://flakehub.com/f/snowfallorg/lib/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # see: https://github.com/cachix/git-hooks.nix
    pre-commit-hooks = {
      url = "https://flakehub.com/f/cachix/git-hooks.nix/0.1.*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      toml = fromTOML (builtins.readFile ./Cargo.toml);
      lib = inputs.snowfall-lib.mkLib rec {
        # snowfall doc: https://snowfall.org/guides/lib/quickstart/
        inherit inputs;
        # root dir
        src = ./.;

        snowfall = {
          root = "${src}/develop";

          namespace = toml.package.name or "example";
          meta = {
            name = "${toml.package.name or "example"}-flake";
            title = "${toml.package.name or "example"}'s Nix Flakes";
          };
        };
      };
    in
    lib.mkFlake {
      outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt-rfc-style; };
    };
}
