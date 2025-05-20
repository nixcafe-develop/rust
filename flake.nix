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
    inputs.snowfall-lib.mkFlake rec {
      inherit inputs;
      src = ./.;
      snowfall.root = "${src}/develop";
    };
}
