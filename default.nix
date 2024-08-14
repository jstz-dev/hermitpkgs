let
  parentNixpkgs = import (fetchTarball {
    url = "https://github.com/jstz-dev/nixpkgs/archive/af72bfbe620a98555bf4b11a8e5e498dffebff83.tar.gz";
    sha256 = "0qmgl8h5kxbga854kkkkh43rqgps9540hrypfijlp7f6qgksg2c2";
  });
  overlay = import ./overlay;
in
  with (parentNixpkgs {
    overlays = [ overlay ];
    crossSystem = {config = "riscv64-hermit";};
    config.allowUnsupportedSystem = true;
  }); pkgs
