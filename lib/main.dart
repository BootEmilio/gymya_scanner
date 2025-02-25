import 'package:flutter/material.dart';
import 'login_screen.dart'; // Importa la pantalla de login
import 'gym_selection_screen.dart'; // Importa la pantalla de selección de gimnasio
import 'qr_scanner_screen.dart'; // Importa la pantalla de escaneo de QR

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
        '/gym_selection': (context) => GymSelectionScreen(gymIds: []), // Ruta para la selección de gimnasio
        '/qr_scanner': (context) => QRScannerScreen(), // Ruta para el escáner de QR
      },
      debugShowCheckedModeBanner: false, // Oculta el banner de "Debug" en la esquina superior derecha
    );
  }
}