import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemini Mobile App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoggedIn = false;

  void _setLoggedIn(bool value) {
    setState(() {
      _isLoggedIn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Gemini Mobile App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
                if (result != null && result) {
                  _setLoggedIn(true);
                }
              },
              child: const Text('Login Menu'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoggedIn
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OdooInfoPage()),
                      );
                    }
                  : null,
              child: const Text('Odoo Info'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    // Placeholder for login logic
    // In a real app, you would make an API call here
    print('Attempting to login with username: ${_usernameController.text} and password: ${_passwordController.text}');
    // Simulate successful login
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

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