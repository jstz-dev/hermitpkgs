final: prev: let
  whenHost = pkg: fix:
    if prev.stdenv.hostPlatform.isHermit
    then pkg.overrideAttrs fix
    else pkg;

  whenTarget = pkg: fix:
    if prev.stdenv.targetPlatform.isHermit
    then pkg.overrideAttrs fix
    else pkg;
in {
  binutils-unwrapped = whenTarget prev.binutils-unwrapped (attrs: {
    src = prev.fetchgit {
      url = "https://github.com/jstz-dev/hermit-binutils.git";
      rev = "refs/heads/binutils-2_42";
      hash = "sha256-Jy2pUDRp3JEP8iqAOpCKztcUKkGchOskdY6JnE87/MY=";
    };
    dontUpdateAutotoolsGnuConfigScripts = true;
    configureFlags = attrs.configureFlags ++ ["--disable-gdb" "--disable-nls"];
    nativeBuildInputs = attrs.nativeBuildInputs ++ (with prev; [flex texinfo]);
    buildInputs = attrs.buildInputs ++ (with prev; [ gmp mpfr ]);
  });
}
