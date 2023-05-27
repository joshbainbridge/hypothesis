{
  description = "A collection of quantile and quadrature routines for Z, Chi^2, and Student's T hypothesis tests";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      # Systems supported
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      packages = forAllSystems ({ pkgs }: {
        default = pkgs.stdenv.mkDerivation {
            name = "hypothesis";
            src = self;
            buildInputs = [
              pkgs.cmake
            ];
            configurePhase = ''
              cmake -B build -D CMAKE_INSTALL_PREFIX=$out
            '';
            installPhase = ''
              cmake --build build --target install
            '';
          };
      });
    };
}
