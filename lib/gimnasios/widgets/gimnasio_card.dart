import 'package:flutter/material.dart';

class GimnasioCard extends StatefulWidget {
  final Map<String, dynamic> gimnasio;
  final VoidCallback onTap;

  const GimnasioCard({required this.gimnasio, required this.onTap, super.key});

  @override
  _GimnasioCardState createState() => _GimnasioCardState();
}

class _GimnasioCardState extends State<GimnasioCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1.0),
      child: InkWell(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isPressed = true), // Cambia el estado al presionar
        onTapCancel: () => setState(() => _isPressed = false), // Restablece el estado al cancelar
        onTapUp: (_) => setState(() => _isPressed = false), // Restablece el estado al soltar
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: _isPressed ? Colors.purple : Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                child: Image.network(
                  widget.gimnasio['imagen'] ?? 'https://via.placeholder.com/150', // URL de la imagen o placeholder
                  width: double.infinity, // Ocupa todo el eje X
                  height: 150, // Puedes ajustar la altura según el diseño
                  fit: BoxFit.cover, // Ajusta la imagen al contenedor
                ),
              ),
              SizedBox(height: 8), // Espacio entre la imagen y el contenido
              Text(
                widget.gimnasio['nombre'] ?? 'Nombre no disponible',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Dirección: ${widget.gimnasio['direccion']}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 4),
              Text(
                'Horario: ${widget.gimnasio['horario']}',
                style: TextStyle(color: Colors.white60),
              ),
            ],
          ),
        ),
      ),
    );
  }
}