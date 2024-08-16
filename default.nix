let
  parentNixpkgs = import (fetchTarball {
    url = "https://github.com/jstz-dev/nixpkgs/archive/cc6fe05137995c9fae76e7638da7f24280f672e3.tar.gz";
    sha256 = "0s55rn8v5klby2gg2hxcw3k3ngxxlgxcc43x0b5zfmncnj244siw";
  });
  overlay = import ./overlay;
in
  with (parentNixpkgs {
    overlays = [ overlay ];
    crossSystem = {config = "riscv64-hermit";};
    config.allowUnsupportedSystem = true;
  }); pkgs
