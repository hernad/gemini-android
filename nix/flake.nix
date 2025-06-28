{
  description = "A Nix-based development environment for the Gemini Android Nix project.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/c7ab75210cb8cb16ddd8f290755d9558edde7ee1";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.flutter
            pkgs.python3
            pkgs.android-studio
            pkgs.androidenv.androidPkgs.emulator
            pkgs.androidenv.androidPkgs.tools
            pkgs.androidenv.androidPkgs.platform-tools
            pkgs.androidenv.androidPkgs.ndk-bundle
          ];
        };
      });
}
