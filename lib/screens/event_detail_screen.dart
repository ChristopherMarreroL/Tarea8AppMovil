import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io';
import '../models/event.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  EventDetailScreen({required this.event});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late FlutterSoundPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = FlutterSoundPlayer();
    _initializeAudioPlayer();
  }

  Future<void> _initializeAudioPlayer() async {
    await _audioPlayer.openPlayer();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _audioPlayer.closePlayer();
    super.dispose();
  }

  void _playPauseAudio() async {
    if (_isPlaying) {
      await _audioPlayer.stopPlayer();
    } else {
      await _audioPlayer.startPlayer(
        fromURI: widget.event.audioPath,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
          });
        },
      );
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Incidencia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text(
              event.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16.0),
            event.photoPath.isNotEmpty
                ? Image.file(
                    File(event.photoPath),
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.image, size: 200),
            SizedBox(height: 16.0),
            Text(
              'Descripción:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(event.description),
            SizedBox(height: 16.0),
            if (event.audioPath.isNotEmpty) 
              ElevatedButton(
                onPressed: _isInitialized ? _playPauseAudio : null,
                child: Text(_isPlaying ? 'Detener Audio' : 'Reproducir Audio'),
              ),
          ],
        ),
      ),
    );
  }
}
