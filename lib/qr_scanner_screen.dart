import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';  // Para escanear códigos QR
import 'package:http/http.dart' as http;           // Para hacer solicitudes HTTP
import 'dart:convert';                             // Para manejar JSON
import 'package:flutter_secure_storage/flutter_secure_storage.dart';  // Para almacenar el token

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  String result = 'Escanea un código QR';  // Mensaje para mostrar el resultado
  final _storage = FlutterSecureStorage(); // Almacenamiento seguro para el token

  Future<void> scanQR() async {
    try {
      // Inicia el escáner de QR
      final scanResult = await BarcodeScanner.scan();

      // Verifica si se escaneó un código QR válido
      if (scanResult.rawContent.isNotEmpty) {
        setState(() {
          result = 'Escaneado: ${scanResult.rawContent}';
        });

        // Parsear el JSON escaneado
        final jsonData = jsonDecode(scanResult.rawContent);
        final membresiaId = jsonData['membresia_id'];  // Extraer el membresia_id
        print('membresiaId escaneado: $membresiaId');  // Depuración

        // Obtener el token guardado
        final token = await _storage.read(key: 'token');
        print('Token obtenido: $token');  // Depuración

        if (token == null) {
          setState(() {
            result = 'No se encontró el token. Inicia sesión nuevamente.';
          });
          return;
        }

        // Enviar datos al servidor para registrar la asistencia
        await registrarAsistencia(membresiaId, token);
      } else {
        setState(() {
          result = 'Código QR no válido';
        });
      }
    } catch (e) {
      // Maneja errores (por ejemplo, si el usuario cancela el escaneo)
      setState(() {
        result = 'Error al escanear: $e';
      });
      print('Error al escanear: $e');  // Depuración
    }
  }

  // Método para registrar la asistencia
  Future<void> registrarAsistencia(String membresiaId, String token) async {
    try {
      // Hacer la solicitud POST a la API
      final response = await http.post(
        Uri.parse('https://api-gymya-api.onrender.com/api/nuevaAsistencia'),  // URL de tu API
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Incluir el token en el encabezado
        },
        body: jsonEncode({
          'membresia_id': membresiaId,  // Enviar solo el membresia_id
        }),
      );

      // Verificar la respuesta del servidor
      print('Respuesta de la API: ${response.body}');  // Depuración

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        setState(() {
          result = responseData['message'] ?? 'Asistencia registrada correctamente';
        });
      } else {
        final errorData = jsonDecode(response.body);
        setState(() {
          result = errorData['error'] ?? 'Error al registrar asistencia';
        });
      }
    } catch (e) {
      setState(() {
        result = 'Error de conexión: $e';
      });
      print('Error en la solicitud POST: $e');  // Depuración
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escanear QR'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(result),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: scanQR,  // Llama a la función para escanear
            child: Text('Escanear QR'),
          ),
        ],
      ),
    );
  }
}