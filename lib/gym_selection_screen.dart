import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'qr_scanner_screen.dart';  // Importa la pantalla de escaneo de QR

class GymSelectionScreen extends StatefulWidget {
  final List<String> gymIds;  // Lista de gymIds del administrador

  GymSelectionScreen({required this.gymIds});

  @override
  _GymSelectionScreenState createState() => _GymSelectionScreenState();
}

class _GymSelectionScreenState extends State<GymSelectionScreen> {
  final _storage = FlutterSecureStorage();
  String? selectedGymId;  // gymId seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Gimnasio'),
      ),
      body: ListView.builder(
        itemCount: widget.gymIds.length,
        itemBuilder: (context, index) {
          final gymId = widget.gymIds[index];
          return ListTile(
            title: Text('Gimnasio ${index + 1} (ID: $gymId)'),
            onTap: () async {
              // Guardar el gymId seleccionado
              await _storage.write(key: 'selectedGymId', value: gymId);
              setState(() {
                selectedGymId = gymId;
              });

              // Navegar a la pantalla de escaneo de QR
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => QRScannerScreen()),
              );
            },
          );
        },
      ),
    );
  }
}