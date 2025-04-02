# How to use Develop Config

### [use template repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)


### Directory structure
```
.
│
├── flake.nix
│
│   # Check if your nix file is formatted before uploading
├── checks 
│   └── pre-commit-check
│       └── default.nix
│
│   # agenix command support
├── shells
│   └── default
│       └── default.nix│
│
│   # direnv: https://github.com/direnv/direnv/wiki/Nix
├── .envrc
│
│   # statix: https://github.com/oppiliappan/statix?tab=readme-ov-file#configuration
└── statix.toml 
```
