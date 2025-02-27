import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'dart:convert';
import 'package:gymya_scanner/Funciones/registrarAsistencias.dart';

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

  Future<void> scanQR() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Inicia el escáner de QR
      final scanResult = await BarcodeScanner.scan();
      print('Valor escaneado (raw): "${scanResult.rawContent}"'); // Depuración detallada

      // Recorta espacios en blanco y nuevos saltos de línea alrededor del contenido
      final trimmedContent = scanResult.rawContent.trim();
      print('Valor escaneado (trimmed): "$trimmedContent"'); // Depuración detallada

      // Verifica si se escaneó un código QR válido
      if (trimmedContent.isNotEmpty) {
        try {
          // Parsear el JSON escaneado
          final jsonData = jsonDecode(trimmedContent);
          print('Datos del JSON: $jsonData');  // Verifica que el JSON sea correcto

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

          // Obtener la fecha y hora actual
          final fechaHora = DateTime.now().toUtc().toIso8601String();
          print('Fecha y hora actual: $fechaHora');  // Depuración

          // Crear una instancia de RegistrarAsistencias con membresiaId y enviar la solicitud
          final registrarasistencias = RegistrarAsistencias(
            token: widget.token,
            gimnasioId: widget.gimnasioId,
            membresiaId: membresiaId,  // Pasa el membresiaId aquí
            fechaHora: fechaHora,
          );

          // Enviar datos al servidor para registrar la asistencia
          await registrarasistencias.registrarAsistencias();

          setState(() {
            result = 'Asistencia registrada correctamente';
          });

        } catch (e) {
          setState(() {
            result = 'Código QR no válido: no es un JSON correcto';
          });
          print('Error al parsear JSON: $e');  // Depuración de errores
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