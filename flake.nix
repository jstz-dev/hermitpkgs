{
  description = "Use Nix to cross-compile packages to Hermit";

  inputs = {
    nixpkgs.url = "github:jstz-dev/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    {
      overlays.default = import ./overlay;
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells.default = pkgs.mkShell {
        packages = [ pkgs.alejandra ];
      };

      formatter = pkgs.alejandra;

      checks = {
        format = pkgs.runCommand "check-fmt" {buildInputs = [pkgs.alejandra];} ''
          alejandra -c ${self}
          touch $out
        '';
      };
    });
}
