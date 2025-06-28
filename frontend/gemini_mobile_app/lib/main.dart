import 'package:flutter/material.dart';
import 'package:gemini_mobile_app/login_page.dart';
import 'package:gemini_mobile_app/odoo_info_page.dart';

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