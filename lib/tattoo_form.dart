import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:inkquest_travissimmons/models/artist.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart'; // Import permission_handler package
import 'dart:io';

import 'models/artist.dart';
import 'result.dart'; // Import the ResultPage widget

class TattooForm extends StatefulWidget {
  const TattooForm({Key? key}) : super(key: key);

  @override
  _TattooFormState createState() => _TattooFormState();
}

class _TattooFormState extends State<TattooForm> {
  String firstName = '';
  String lastName = '';
  int age = 0;
  String gender = '';
  String tattooDescription = '';
  String tattooSize = ''; // Change tattooSize type to String
  String tattooStyle = '';
  String tattooPlacement = '';
  List<File> selectedFiles = [];

  final List<String> tattooStyles = [
    'Traditional',
    'Neo-Traditional',
    'Realism',
    'Water-Colour'
  ];

  // List of available tattoo sizes
  final List<String> tattooSizeOptions = ['Small', 'Medium', 'Large'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tattoo Form'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Existing form fields...
            Text('First Name'),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  firstName = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text('Last Name'),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  lastName = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text('Age'),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  age = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text('Gender'),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  gender = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text('Tattoo Description'),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  tattooDescription = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text('Tattoo Size'),
            DropdownButtonFormField<String>(
              value: null,
              onChanged: (value) {
                setState(() {
                  tattooSize = value!;
                });
              },
              items: tattooSizeOptions.map((size) {
                return DropdownMenuItem<String>(
                  value: size,
                  child: Text(size),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text('Tattoo Style'),
            DropdownButtonFormField<String>(
              value: null,
              onChanged: (value) {
                setState(() {
                  tattooStyle = value!;
                });
              },
              items: tattooStyles.map((style) {
                return DropdownMenuItem<String>(
                  value: style,
                  child: Text(style),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text('Tattoo Placement'),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  tattooPlacement = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Request storage permission
                var status = await Permission.storage.request();
                if (status.isGranted) {
                  // Permission granted, proceed with file selection
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.image,
                    allowMultiple: true,
                  );
                  if (result != null) {
                    setState(() {
                      selectedFiles =
                          result.paths!.map((path) => File(path!)).toList();
                    });
                  } else {
                    // User canceled the picker
                  }
                } else {
                  // Permission denied, inform the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Storage permission denied')),
                  );
                }
              },
              child: Text('Select Photos'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Check if photos are selected
                if (selectedFiles.isNotEmpty) {
                  // Upload photos to Firebase Storage
                  for (File file in selectedFiles) {
                    String fileName = file.path.split('/').last;
                    try {
                      firebase_storage.Reference ref = firebase_storage
                          .FirebaseStorage.instance
                          .ref()
                          .child('uploads/$fileName');
                      await ref.putFile(file);
                      String downloadURL = await ref.getDownloadURL();
                      // Store the download URL in Firebase Firestore along with other form data
                      // You can modify submissionData to include the photo URLs
                    } catch (error) {
                      print('Error uploading photo: $error');
                      // Handle error
                    }
                  }
                } else {
                  // Inform the user to select photos
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select photos')),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
