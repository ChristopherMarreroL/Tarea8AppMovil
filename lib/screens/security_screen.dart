import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SecurityScreen extends StatelessWidget {

  final String boxName = 'eventosBox';

  Future<void> _deleteAllRecords() async {
    final box = await Hive.openBox(boxName);


    await box.clear();
    

    await box.close();

    // Muestra un mensaje de éxito o actualiza la UI
    print('Todos los registros han sido borrados.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seguridad'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _deleteAllRecords();
            // Puedes mostrar un mensaje de éxito o redirigir al usuario
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Todos los registros han sido borrados.')),
            );
          },
          child: Text('Borrar todos los registros'),
        ),
      ),
    );
  }
}
