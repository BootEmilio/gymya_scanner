import 'package:flutter/material.dart';
import 'package:gymya_scanner/Funciones/registrarAsistencias.dart';
import 'package:gymya_scanner/scanner/widgets/header.dart';

class QRScannerScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;
  final String gimnasioId;

  QRScannerScreen({super.key, required this.token, required this.user, required this.gimnasioId});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  String result = 'Escanea un código QR';  // Mensaje para mostrar el resultado
  bool _isLoading = false;

  // Función para escanear el QR y registrar la asistencia
  Future<void> scanQR() async {
    setState(() {
      _isLoading = true;
    });

    final registrarAsistencias = RegistrarAsistencias(
      token: widget.token,
      gimnasioId: widget.gimnasioId,
    );

    final scanResult = await registrarAsistencias.scanAndRegisterAttendance();

    setState(() {
      result = scanResult;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 35),
          const Header(),
          Expanded( // Esto expande el área restante
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente los elementos
              children: [
                Center(
                  child: Text(
                    result,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator(
                        color: Colors.purple,
                      )
                    : ElevatedButton(
                        onPressed: scanQR, // Llama a la función para escanear
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple, // Color de fondo del botón
                          foregroundColor: Colors.white,  // Color del texto del botón
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Bordes redondeados
                          ),
                        ),
                        child: Text('Escanear QR'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}