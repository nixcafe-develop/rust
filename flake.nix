{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
    purr.url = "https://flakehub.com/f/nixcafe/purr/0.1.*.tar.gz";

    git-hooks = {
      url = "https://flakehub.com/f/cachix/git-hooks.nix/0.1.*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.purr.lib.mkFlake {
      inherit inputs;
      src = ./develop;
    };
}
