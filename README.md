# Hermitpkgs

> Hermitpkgs is an overlay to allow using Nix to cross-compile packages to [Hermit OS](https://github.com/hermit-os/kernel). 

## Usage

To compile the gcc cross-compiler:
```sh
nix-build . -A buildPackages.gcc
```
