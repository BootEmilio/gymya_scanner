import 'package:flutter/material.dart';
import 'login_screen.dart'; // Importa la pantalla de login

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gymya App', // Nombre de la aplicación
      theme: ThemeData(
        primarySwatch: Colors.blue, // Color principal de la aplicación
      ),
      home: LoginScreen(), // Pantalla de inicio (LoginScreen)
      routes: {
        // Define las rutas de navegación
        '/login': (context) => LoginScreen(),
      },
      debugShowCheckedModeBanner: false, // Oculta el banner de "Debug" en la esquina superior derecha
    );
  }
}