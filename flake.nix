{
  description = "neovim packages build environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/705476eae4560fed491b8b3c1f6a87adf9c7c035";
    flake-utils.url = "github:numtide/flake-utils/c0e246b9b83f637f4681389ecabcb2681b4f3af0";
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
