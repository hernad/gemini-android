{
    'name': 'Gemini Backend',
    'version': '1.0',
    'summary': 'Custom module for Gemini mobile application backend',
    'sequence': 10,
    'description': """
        This module provides the backend functionalities for the Gemini mobile application,
        including Odoo server information and authentication endpoints.
    """,
    'category': 'Custom',
    'website': 'https://github.com/hernad/gemini-android-nix',
    'depends': ['base', 'rest_framework', 'auth_oidc'],
    'data': [],
    'demo': [],
    'installable': True,
    'application': True,
    'auto_install': False,
    'license': 'LGPL-3',
}