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
          config = {
            allowUnfree = true;
             android_sdk.accept_license = true;
          };
        };

         android_sdk.accept_license = true;
      in
      {
        
        devShell = pkgs.mkShell {
          buildInputs = [
            # https://discourse.nixos.org/t/launching-emulator-without-android-studio/54933
            (pkgs.androidenv.emulateApp {
              name = "emulate-android";
              platformVersion = "35";
              abiVersion = "x86_64"; # armeabi-v7a, mips, x86_64
              systemImageType = "google_apis_playstore";
            })
            pkgs.flutter
            pkgs.dart
            pkgs.python3
            pkgs.python3Packages.pip
            pkgs.python3Packages.venvShellHook
            pkgs.odoo16
            #odoo  #Name: odooVersion: 18.0.20250506
            pkgs.android-studio
            pkgs.androidenv.androidPkgs.emulator
            pkgs.androidenv.androidPkgs.tools
            pkgs.androidenv.androidPkgs.platform-tools
            pkgs.androidenv.androidPkgs.ndk-bundle
          ];

          # https://github.com/LongerHV/nixos-configuration/blob/e3251efce564330977ff2555648982f126c26327/shells/pythonVenv.nix#L6
          venvDir = "./.venv";
          postVenvCreation = ''
            unset SOURCE_DATE_EPOCH
          '';
          postShellHook = ''
            unset SOURCE_DATE_EPOCH
          '';

          #https://discourse.nixos.org/t/cant-start-android-studio-emulators-on-nixos/61536

          shellHook = ''
            export QT_QPA_PLATFORM=xcb
            echo QT_QPA_PLATFORM=$QT_QPA_PLATFORM
          '';  

        };
      });
}
