{stdenv}:
stdenv.mkDerivation {
  name = "hermit-hello-world";
  src = ./src;

  hardeningEnable = [ "pic" "pie" ];
  
  buildPhase = ''
    $CC -fPIC -fPIE -pie -ggdb -o main.o $src/main.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp main.o $out/bin
  '';
}