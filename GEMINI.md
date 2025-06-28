# Odoo bring.out mobile project

## Technology stack

As starting point use this technologies:
1. we use NixOS system, nix flakes for development
2. flutter for frontend
3. Odoo ERP for backend
4. We will use exclusively Odoo community (open source) edition, v16
5. As much as possible use module from Odoo Community association (https://odoo-community.org/, https://github.com/OCA) 
6. For backend base use this module: OCA module rest-framework(fastapi) https://github.com/OCA/rest-framework/tree/16.0/fastapi


## Mobile frontend

Create application with two options:
1. "Login menu" option which launches Login form to access backend service
2. "Odoo Info" option. Initially, this option is disabled. After successful login, it show these info on screen:
 -  Odoo server version
 -  modules installed on server


## Odoo Server backend

1. Authentication workflow is provided by https://github.com/OCA/server-auth/tree/16.0/auth_oidc, so provide all necessary endpoints for client
2. /info endpoint, provides data for frontend "Odoo info"


## Source code

Publish and maintain Source code on github.com/hernad/gemini-android-nix.
In that purpose create repository on github



