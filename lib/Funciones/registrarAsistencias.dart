import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barcode_scan2/barcode_scan2.dart';

class RegistrarAsistencias {
  final String token;
  final String gimnasioId;

  RegistrarAsistencias({
    required this.token,
    required this.gimnasioId,
  });

  // Método para escanear y registrar la asistencia
  Future<String> scanAndRegisterAttendance() async {
    try {
      // Inicia el escáner de QR
      final scanResult = await BarcodeScanner.scan();
      final trimmedContent = scanResult.rawContent.trim();

      if (trimmedContent.isEmpty) {
        return 'No se encontró un código QR válido';
      }

      // Parsear el JSON escaneado
      final jsonData = jsonDecode(trimmedContent);
      if (jsonData['membresia_id'] == null) {
        return 'Código QR no válido';
      }

      final membresiaId = jsonData['membresia_id'];

      // Obtener la fecha y hora actual
      final fechaHora = DateTime.now().toUtc().toIso8601String();

      // Llamada a la API para registrar la asistencia
      return await registrarAsistencias(membresiaId, fechaHora);
      
    } catch (e) {
      return 'Error al escanear o registrar asistencia: ${e.toString()}';
    }
  }

  // Método para registrar la asistencia en la API
  Future<String> registrarAsistencias(String membresiaId, String fechaHora) async {
    final response = await http.post(
      Uri.parse('https://api-gymya-api.onrender.com/api/$gimnasioId/nuevaAsistencia'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'membresia_id': membresiaId,
        'fecha_hora': fechaHora,
      }),
    );

    if (response.statusCode == 201) {
      return 'Asistencia registrada correctamente';
    } else {
      print('Error en la respuesta: ${response.body}');
      return 'Error al registrar la asistencia: ${response.statusCode}';
    }
  }
}