import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Imagen
            Image.asset(
              'assets/multimedia/fotomiacopia.jpg',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            // Información personal
            Text(
              'Nombre: Christopher E.\nApellido: Marrero L.\nMatrícula: 2022-0997.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Reflexión sobre seguridad
            Text(
              '“La seguridad no es un producto, es un proceso.”\n- Bruce Schneier',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
