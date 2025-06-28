# Odoo Backend

This directory contains the Odoo backend for the Gemini mobile project.

## Odoo Version

Odoo Community Edition, version 16.

## Custom Addons

Custom Odoo modules are located in the `custom_addons` directory.

### `gemini_backend`

This module provides custom endpoints for the mobile application, including:
- `/info`: Provides Odoo server version and installed modules information.

### OCA Modules

We utilize modules from the Odoo Community Association (OCA). Specifically:
- `rest-framework`: Used for building RESTful APIs with FastAPI.
- `server-auth`: Provides authentication workflows, including OIDC.

## Development Environment

The development environment is managed using Nix flakes. Refer to `nix/flake.nix` for details on setting up the environment with Odoo and other dependencies.

## Running the Odoo Backend

To run the Odoo backend, you'll need to:

1.  **Enter the Nix development shell:** This ensures you have the correct Odoo environment set up.

    ```bash
    nix develop
    ```

2.  **Start the Odoo server:** Once inside the Nix shell, you can start Odoo. You'll need to specify the `addons_path` to include your custom modules and the OCA modules you just cloned.

    A typical command would look like this (you might need to adjust the paths based on your exact setup and where Odoo is installed by Nix):

    ```bash
    odoo -c /path/to/your/odoo.conf \
        --addons-path=/home/hernad/ai/gemini-android-nix/backend/custom_addons,/path/to/odoo/default/addons -d \
        your_database_name --xmlrpc-port=8069 --http-port=8070
    ```

    *   Replace `/path/to/your/odoo.conf` with the path to your Odoo configuration file (if you have one).
    *   Replace `/path/to/odoo/default/addons` with the path to Odoo's default addons directory (this is usually handled by Nix).
    *   `your_database_name` is the name of the Odoo database you want to use.
    *   `--xmlrpc-port` and `--http-port` are examples; adjust as needed.

    **Important:** The `rest-framework` and `auth_oidc` modules (from `server-auth`) will need to be installed in your Odoo database once the server is running. You can do this through the Odoo web interface (Apps menu).
