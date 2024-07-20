import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/event.dart';
import 'event_detail_screen.dart';
import 'dart:io';

class ViewEventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Incidencias'),
      ),
      body: FutureBuilder(
        future: Hive.openBox<Event>('events'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar eventos'));
          }
          final box = Hive.box<Event>('events');
          final events = box.values.toList().cast<Event>();

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                leading: event.photoPath.isNotEmpty
                    ? Image.file(
                        File(event.photoPath),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.image),
                title: Text(event.title),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailScreen(event: event),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
