{
  description = "FreeCAD-realthunder package from git";

  inputs = {
    nixpkgs.url = "nixpkgs";
    freecad-realthunder = {
      url = "github:realthunder/FreeCAD/LinkStable";
      flake = false;
    };
  };

  outputs = {nixpkgs, ...}:
  let
    systems = ["x86_64-linux" "aarch64-linux"];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (sys: f nixpkgs.legacyPackages.${sys});
  in rec {
    packages = forAllSystems (pkgs: {
      default = pkgs.libsForQt5.callPackage ./package.nix {
        boost = pkgs.python3Packages.boost;
        inherit (python3Packages)
          gitpython
          matplotlib
          pivy
          ply
          pycollada
          pyside2
          pyside2-tools
          python
          pyyaml
          scipy
          shiboken2;
      };
    });
    devShells = forAllSystems (pkgs: {
      default = let
        inherit (packages.${pkgs.system}) default;
        inherit (pkgs) lib mkShell;
      in
        mkShell {
          inputsFrom = [default];
        };
    });
  };
}
