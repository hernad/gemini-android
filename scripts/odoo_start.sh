#!/usr/bin/env bash

nix develop -c bash -c "python ./odoo-16/odoo-bin -c odoo.conf"
