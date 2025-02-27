import 'package:flutter/material.dart';
import 'package:gymya_scanner/Funciones/listaGimnasios.dart';
import '../qr_scanner_screen.dart';  // Importa la pantalla de escaneo de QR
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
    try{
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
          gimnasioId : gimnasioId,
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 50),
          const Header(),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.purple))
                : ListView.builder(
                  itemCount: gimnasios.length,
                  itemBuilder: (context, index) {
                    final gimnasio = gimnasios[index];
                    return GimnasioCard(
                      gimnasio: gimnasio,
                      onTap: () => goToNextScreen(gimnasio['_id']),
                    );
                  },
                ),
          )
        ],
      ),
    );
  }
}