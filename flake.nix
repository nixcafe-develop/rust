{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      toml = fromTOML (builtins.readFile ./Cargo.toml);
      lib = inputs.snowfall-lib.mkLib {
        # snowfall doc: https://snowfall.org/guides/lib/quickstart/
        inherit inputs;
        # root dir
        src = ./.;

        snowfall = {
          namespace = toml.package.name or "example";
          meta = {
            name = "${toml.package.name or "example"}-flake";
            title = "${toml.package.name or "example"}'s Nix Flakes";
          };
        };
      };
    in
    lib.mkFlake {

      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [ ];
      };

      outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt-rfc-style; };
    };
}
