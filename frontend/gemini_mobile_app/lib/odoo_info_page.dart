import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OdooInfoPage extends StatefulWidget {
  const OdooInfoPage({super.key});

  @override
  State<OdooInfoPage> createState() => _OdooInfoPageState();
}

class _OdooInfoPageState extends State<OdooInfoPage> {
  String _odooVersion = 'Loading...';
  String _installedModules = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchOdooInfo();
  }

  Future<void> _fetchOdooInfo() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8069/api/gemini/info')); // Assuming Odoo runs on 8069
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['result'];
        setState(() {
          _odooVersion = data['odoo_version'].toString();
          _installedModules = (data['installed_modules'] as List).join(', ');
        });
      } else {
        setState(() {
          _odooVersion = 'Error: ${response.statusCode}';
          _installedModules = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _odooVersion = 'Error: $e';
        _installedModules = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Odoo Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Odoo Server Version:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_odooVersion),
            const SizedBox(height: 20),
            const Text(
              'Installed Modules:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_installedModules),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
