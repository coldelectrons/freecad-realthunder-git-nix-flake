{
  description = "FreeCAD-realthunder package from git";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    freecad-realthunder.url = "github:realthunder/FreeCAD/LinkStable";
    freecad-realthunder.flake = false;
  };

  outputs = { nixpkgs, ... }@inputs: {
    packages = builtins.listToAttrs (map
      (system: {
        name = system;
        value = with import nixpkgs { inherit system; }; rec {

          default = freecad-realthunder;

          freecad-realthunder = pkgs.libsForQt5.callPackage ./package.nix {
            boost = python3Packages.boost;
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

        };
      }) [ "x86_64-linux" "aarch64-linux" ]);
  };
}
