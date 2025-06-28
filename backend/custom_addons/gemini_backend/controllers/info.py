from odoo.http import request
from odoo.addons.rest_framework.controllers.main import ApiController

class GeminiInfoController(ApiController):
    _name = "gemini.info.controller"

    @request.route('/api/gemini/info', type='json', auth='public', methods=['GET'])
    def get_info(self):
        info_data = request.env['gemini.info'].get_odoo_info()
        return self.response_ok(info_data)
