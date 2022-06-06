{
  description = "neovim packages build environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { system = system; };
      in
      {
        devShell = pkgs.mkShell {
          name = "neovim-pkgs-shell";

          buildInputs = [
            pkgs.nixpkgs-fmt
          ];
        };
      });
}
