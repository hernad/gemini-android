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
      in
      {
        
        devShell = pkgs.mkShell {
          buildInputs = [
            emulateApp
            pkgs.flutter
            pkgs.dart
            pkgs.python311
            pkgs.python311Packages.pip
            pkgs.android-studio
            pkgs.androidenv.androidPkgs.emulator
            pkgs.androidenv.androidPkgs.tools
            pkgs.androidenv.androidPkgs.platform-tools
            pkgs.androidenv.androidPkgs.ndk-bundle
            pkgs.postgresql
            pkgs.postgresql.dev
            pkgs.unzip
            pkgs.curl
          ];

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
            pg_ctl -o "-k $PWD/run" -D "$PGDATA" -l postgres.log stop || true
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

            echo "Setting up Python virtual environment for Odoo..."
            if [ ! -d ".venv_odoo" ]; then
              ${pkgs.python311}/bin/python -m venv .venv_odoo
            fi
            export PATH=$PATH:${pkgs.postgresql.dev}/bin
            source .venv_odoo/bin/activate
            pip install fastapi uvicorn a2wsgi apispec cerberus cryptography graphene itsdangerous jsondiff marshmallow pydantic pyjwt python-multipart typing-extensions ujson
            echo "Python virtual environment activated and dependencies installed."

            echo "Odoo configured to use PostgreSQL."
            if [ ! -d "odoo-16" ]; then
              echo "Downloading Odoo 16 distribution..."
              curl -L https://download.cloud.out.ba/odoo-16-bosnian-20250430.zip -o odoo-16.zip
              unzip odoo-16.zip -d .
              rm odoo-16.zip
            fi

            pip install -r odoo-16/requirements.txt

            echo "Run odoo with: python ./odoo-16/odoo-bin -c odoo.conf"
          '';

        };
      });
}
