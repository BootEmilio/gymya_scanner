import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el ancho de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.07, // Ajusta el padding según el ancho 
        vertical: 1.0
      ),
      child: Center(
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [const Color.fromRGBO(156, 39, 176, 1), Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: Text(
            'Gimnasios', // Texto actualizado
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.07,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}