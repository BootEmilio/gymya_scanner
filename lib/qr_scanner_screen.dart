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
  final _storage = FlutterSecureStorage(); // Almacenamiento seguro para el token y el gymId
  bool _isLoading = false;

  Future<void> scanQR() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Obtener el gymId seleccionado
      final selectedGymId = await _storage.read(key: 'selectedGymId');
      if (selectedGymId == null) {
        setState(() {
          result = 'No se ha seleccionado un gimnasio.';
        });
        return;
      }

      // Inicia el escáner de QR
      final scanResult = await BarcodeScanner.scan();
      print('Valor escaneado: ${scanResult.rawContent}'); // Depuración

      // Verifica si se escaneó un código QR válido
      if (scanResult.rawContent.isNotEmpty) {
        try {
          // Parsear el JSON escaneado
          final jsonData = jsonDecode(scanResult.rawContent);
          if (jsonData['membresia_id'] == null || jsonData['plan_id'] == null) {
            setState(() {
              result = 'Código QR no válido: falta membresia_id o plan_id';
            });
            return;
          }
          final membresiaId = jsonData['membresia_id'];
          final planId = jsonData['plan_id'];

          print('membresia_id: $membresiaId'); // Depuración
          print('plan_id: $planId'); // Depuración

          // Obtener el token guardado
          final token = await _storage.read(key: 'token');
          print('Token obtenido: $token');  // Depuración

          if (token == null) {
            setState(() {
              result = 'No se encontró el token. Inicia sesión nuevamente.';
            });
            return;
          }

          // Obtener la fecha y hora actual
          final fechaHora = DateTime.now().toUtc().toIso8601String();
          print('Fecha y hora actual: $fechaHora');  // Depuración

          // Enviar datos al servidor para registrar la asistencia
          await registrarAsistencia(selectedGymId, membresiaId, planId, fechaHora, token);
        } catch (e) {
          setState(() {
            result = 'Código QR no válido: no es un JSON correcto';
          });
          return;
        }
      } else {
        setState(() {
          result = 'Código QR no válido';
        });
      }
    } catch (e) {
      setState(() {
        result = 'Error al escanear: ${e.toString()}';
      });
      print('Error al escanear: $e');  // Depuración
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Método para registrar la asistencia
  Future<void> registrarAsistencia(String gymId, String membresiaId, String planId, String fechaHora, String token) async {
    try {
      // Construir la URL de la API con el gymId
      final url = 'https://api-gymya-api.onrender.com/api/$gymId/nuevaAsistencia';

      // Datos a enviar
      final body = {
        'membresia_id': membresiaId,
        'plan_id': planId,
        'fecha_hora': fechaHora,
      };

      // Depuración: Imprimir datos enviados
      print('Datos enviados al servidor:');
      print(jsonEncode(body));

      // Hacer la solicitud POST a la API
      final response = await http.post(
        Uri.parse(url),  // URL dinámica con el gymId
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Incluir el token en el encabezado
        },
        body: jsonEncode(body),
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
          result = 'Error: ${errorData['error']} (Código: ${response.statusCode})';
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
          _isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: scanQR,  // Llama a la función para escanear
                  child: Text('Escanear QR'),
                ),
        ],
      ),
    );
  }
}