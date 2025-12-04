import 'package:flutter/foundation.dart'; // <--- AGREGA ESTO
import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

// SI USAS EMULADOR:
const API_BASE = "http://127.0.0.1:8000";


// SI USAS CELULAR REAL, CAMBIAR POR TU IP LOCAL
// const API_BASE = "http://192.168.x.x:8000";
