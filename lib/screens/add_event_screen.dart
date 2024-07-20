import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Para el formateo de fechas
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart'; // Para almacenar audio

import '../models/event.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  DateTime _date = DateTime.now();
  String _description = '';
  File? _photo;
  String? _audioPath;

  final ImagePicker _picker = ImagePicker();
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder.openRecorder();
  }

  @override
  void dispose() {
    _audioRecorder.closeRecorder();
    super.dispose();
  }

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _photo = File(pickedFile.path);
      });
    }
  }

  void _recordAudio() async {
    if (_isRecording) {
      // Detiene la grabación
      String? result = await _audioRecorder.stopRecorder();
      setState(() {
        _audioPath = result;
        _isRecording = false;
      });
    } else {
      // Comienza la grabación
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path + '/temp_audio.m4a';
      await _audioRecorder.startRecorder(toFile: tempPath);
      setState(() {
        _audioPath = tempPath;
        _isRecording = true;
      });
    }
  }

  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var newEvent = Event()
        ..title = _title
        ..date = _date
        ..description = _description
        ..photoPath = _photo?.path ?? ''
        ..audioPath = _audioPath ?? '';

      var box = Hive.box<Event>('events');
      try {
        await box.add(newEvent);
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Se ha guardado correctamente')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocurrió un error al guardar')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Incidencia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un título';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              SizedBox(height: 16.0),
              ListTile(
                title: Text('Fecha: ${DateFormat.yMd().format(_date)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _date) {
                    setState(() {
                      _date = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 16.0),
              ListTile(
                title: Text(_photo == null ? 'Agregar Foto' : 'Foto seleccionada'),
                trailing: Icon(Icons.photo_camera),
                onTap: _pickImage,
              ),
              SizedBox(height: 16.0),
              if (_photo != null) 
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.file(
                    _photo!,
                    height: 200.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 16.0),
              ListTile(
                title: Text(_audioPath == null
                    ? (_isRecording ? 'Detener Grabación' : 'Grabar Audio')
                    : 'Audio grabado'),
                trailing: Icon(Icons.mic),
                onTap: _recordAudio,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveEvent,
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}