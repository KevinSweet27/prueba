import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final txtUser = TextEditingController();
  final txtPass = TextEditingController();
  bool loading = false;

  Future<void> login() async {
    if (txtUser.text.isEmpty || txtPass.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor ingresa email y contraseña")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final url = Uri.parse("$API_BASE/login");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": txtUser.text.trim(),
          "password": txtPass.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["access_token"] == null) {
          throw Exception("No se recibió token desde el servidor");
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["access_token"]);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        final error = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${error["detail"]}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de conexión: $e")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 40),
            const Text("Login", style: TextStyle(fontSize: 28)),

            const SizedBox(height: 20),
            const Text("Email"),
            TextField(controller: txtUser),

            const SizedBox(height: 15),
            const Text("Password"),
            TextField(controller: txtPass, obscureText: true),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: loading ? null : login,
              child:
                  loading ? const CircularProgressIndicator() : const Text("Entrar"),
            ),
          ],
        ),
      ),
    );
  }
}
