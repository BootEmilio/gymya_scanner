import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrarAsistencias {
  final String token;
  final String gimnasioId;
  final String membresiaId;
  final String fechaHora;

  RegistrarAsistencias({
    required this.token,
    required this.gimnasioId,
    required this.membresiaId,
    required this.fechaHora,
  });

  // Método para registrar la asistencia
  Future<Map<String, dynamic>> registrarAsistencias() async {
    final response = await http.post(
      Uri.parse('https://api-gymya-api.onrender.com/api/$gimnasioId/nuevaAsistencia'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'membresia_id': membresiaId, // Incluir el planId en el cuerpo de la solicitud si es necesario
        'fecha_hora': fechaHora,
      }),
    );

    // Manejar código de éxito 201 (Created)
    if (response.statusCode == 201) {
      // Decodificar la respuesta en JSON
      final responseBody = json.decode(response.body);

      // Verificar si la respuesta es un mapa JSON
      if (responseBody is Map<String, dynamic>) {
        return responseBody; // Retornar el objeto JSON
      } else {
        throw Exception('Formato de respuesta inválido');
      }
    } else {
      // Si no es un código de éxito, lanza una excepción con el mensaje de error
      print('Error en la respuesta: ${response.body}');
      throw Exception('Error al registrar la asistencia: ${response.statusCode}');
    }
  }
}