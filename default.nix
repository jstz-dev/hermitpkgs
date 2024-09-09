let
  parentNixpkgs = import (fetchTarball {
    url = "https://github.com/jstz-dev/nixpkgs/archive/ccc104a4912643da2397ea7649f129931fcfa985.tar.gz";
    sha256 = "1ji9kkzyd9yxm83z6y06dasshgdqp49bk1ka6xj4749hkb1q2pyb";
  });
  # parentNixpkgs = import ../nixpkgs; # for local testing

  overlay = import ./overlay;
in
  with (parentNixpkgs {
    overlays = [ overlay ];
    crossSystem = {config = "riscv64-hermit";};
    config.allowUnsupportedSystem = true;
  }); pkgs
