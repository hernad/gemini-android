from odoo import models, api

class GeminiInfo(models.AbstractModel):
    _name = 'gemini.info'
    _description = 'Gemini Info Endpoint'

    @api.model
    def get_odoo_info(self):
        version_info = self.env['ir.module.module'].get_odoo_version_info()
        installed_modules = self.env['ir.module.module'].search([('state', '=', 'installed')]).mapped('name')
        return {
            'odoo_version': version_info,
            'installed_modules': installed_modules,
        }
