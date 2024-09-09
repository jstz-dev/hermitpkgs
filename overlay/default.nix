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

  icu = whenHost prev.icu (attrs: {
    dontUpdateAutotoolsGnuConfigScripts = true; 
    patches = [ ./patches/icu.patch ];
    patchFlags = [ "-p3" ];
  });

  nspr = whenHost prev.nspr (attrs: {
    dontUpdateAutotoolsGnuConfigScripts = true;
    patches = [ ./patches/nspr.patch ];
    env.NIX_CFLAGS_COMPILE = "-fpermissive";
  
    configureFlags = attrs.configureFlags ++ [
      # NSPR seems to treat host / target differently to Nix for cross 
      # compilation. We instead set them directly (host = build, target = host)
      "--host=${final.stdenv.buildPlatform.config}"
      "--target=${final.stdenv.hostPlatform.config}"
    ];

    # mkDerivation automatically adds --build/--host to configureFlags when cross compiling
    # These defaults do not work for NSPR
    configurePlatforms = [ ];
    
    # We simply want a single output build for now 
    outputs = [ "out" ];
    outputBin = "out";

    # Post install phase deletes archives (static libs)
    postInstall = "";
  });

  # New Hermit Packages
  hermitPkgs = 
    {
      # kernel = final.callPackage ../pkgs/hermit-kernel.nix {};
      hello-world = final.callPackage ../pkgs/hermit-hello-world {};
    };
}
