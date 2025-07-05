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

        # https://discourse.nixos.org/t/launching-emulator-without-android-studio/54933
        emulateApp = pkgs.androidenv.emulateApp {
              name = "emulate-android";
              platformVersion = "35";
              abiVersion = "x86_64"; # armeabi-v7a, mips, x86_64
              systemImageType = "google_apis_playstore";
        };

        myPython = pkgs.python3.withPackages (ps: with ps; [
          fastapi
          uvicorn
          a2wsgi
          apispec
          cerberus
          contextvars
          cryptography
          extendable-pydantic
          extendable
          graphene
          graphql-server
          itsdangerous
          jsondiff
          marshmallow
          marshmallow-objects
          parse-accept-language
          pydantic
          pyjwt
          pyquerystring
          python-multipart
          typing-extensions
          ujson
        ]);
      in
      {
        
        devShell = pkgs.mkShell {
          buildInputs = [
            emulateApp
            pkgs.flutter
            pkgs.dart
            myPython
            pkgs.odoo16
            #odoo  #Name: odooVersion: 18.0.20250506
            pkgs.android-studio
            pkgs.androidenv.androidPkgs.emulator
            pkgs.androidenv.androidPkgs.tools
            pkgs.androidenv.androidPkgs.platform-tools
            pkgs.androidenv.androidPkgs.ndk-bundle
            pkgs.postgresql
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

            alias android_emulator='${emulateApp}/bin/run-test-emulator'

            echo "run 'android_emulator'" 

            # PostgreSQL setup
            export PGDATA=$PWD/data
            export PGDATABASE=postgres
            export PGUSER=postgres
            export PGPASSWORD=postgres
            export PGHOST=localhost
            export PGPORT=5432

            if [ ! -d "$PGDATA" ]; then
              initdb -D "$PGDATA" --no-locale --encoding=UTF8 --username=postgres
            fi

            mkdir -p run
            pg_ctl -o "-k $PWD/run" -D "$PGDATA" -l postgres.log start

            # Create odoo user if it doesn't exist
            psql -tc "SELECT 1 FROM pg_user WHERE usename = 'odoo'" | grep -q 1 || createuser -s -d -r -l odoo
            psql -c "ALTER USER odoo WITH PASSWORD 'odoo';"

            # Create odoo.conf
            cat > odoo.conf <<EOF
            [options]
            addons_path = $PWD/backend/custom_addons/rest-framework,$PWD/backend/custom_addons/server-auth,$PWD/backend/custom_addons,$PWD/backend/custom_addons/web-api
            admin_passwd = admin
            db_host = $PGHOST
            db_port = $PGPORT
            db_user = odoo
            db_password = odoo
            EOF

            echo "Odoo configured to use PostgreSQL."
            echo "Run odoo with: odoo -c odoo.conf"
          '';

        };
      });
}
