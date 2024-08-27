let
  parentNixpkgs = import (fetchTarball {
    url = "https://github.com/jstz-dev/nixpkgs/archive/077b4d34b627c57c4e2275a1e00347ff06e2a20c.tar.gz";
    sha256 = "1bm06i0s328280svrgmc22vgbcxmx2f81zbnac63wb3gk6jj3pdc";
  });
  # parentNixpkgs = import ../nixpkgs; 

  overlay = import ./overlay;
in
  with (parentNixpkgs {
    overlays = [ overlay ];
    crossSystem = {config = "riscv64-hermit";};
    config.allowUnsupportedSystem = true;
  }); pkgs
