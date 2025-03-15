import 'package:flutter/material.dart';
import 'package:gymya_scanner/Funciones/listaGimnasios.dart';
import 'package:gymya_scanner/scanner/qr_scanner_screen.dart';  // Importa la pantalla de escaneo de QR
import 'package:gymya_scanner/gimnasios/widgets/header.dart';
import 'package:gymya_scanner/gimnasios/widgets/gimnasio_card.dart';

class GymSelectionScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> admin;

  GymSelectionScreen({super.key, required this.token, required this.admin});

  @override
  _GymSelectionScreenState createState() => _GymSelectionScreenState();
}

class _GymSelectionScreenState extends State<GymSelectionScreen> {
  List<dynamic> gimnasios = [];
  bool isLoading = true;
  late listaGimnasios _listaGimnasios;

  @override
  void initState() {
    super.initState();
    _listaGimnasios = listaGimnasios(token: widget.token);
    fetchGimnasios();
  }

  Future<void> fetchGimnasios() async {
    try {
      final data = await _listaGimnasios.fetchGimnasios();
      setState(() {
        gimnasios = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void goToNextScreen(String gimnasioId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScannerScreen(
          token: widget.token,
          user: widget.admin,
          gimnasioId: gimnasioId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos la orientación y el tamaño de la pantalla
    final orientation = MediaQuery.of(context).orientation;
    final crossAxisCount = orientation == Orientation.portrait ? 1 : 2;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 50),
          const Header(),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Colors.purple),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount, // 1 columna en portrait, 2 en landscape
                      crossAxisSpacing: 1.0, // Espacio entre columnas
                      mainAxisSpacing: 10.0, // Espacio entre filas
                      childAspectRatio: 1.2, // Ajustamos el ratio para hacer las cards más anchas
                    ),
                    itemCount: gimnasios.length,
                    itemBuilder: (context, index) {
                      final gimnasio = gimnasios[index];
                      return GimnasioCard(
                        gimnasio: gimnasio,
                        onTap: () => goToNextScreen(gimnasio['_id']),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}