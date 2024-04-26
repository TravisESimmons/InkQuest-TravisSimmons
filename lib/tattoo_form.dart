import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:inkquest_travissimmons/models/artist.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'dart:io';
import 'result.dart';

class TattooForm extends StatefulWidget {
  const TattooForm({Key? key}) : super(key: key);

  @override
  _TattooFormState createState() => _TattooFormState();
}

class _TattooFormState extends State<TattooForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String firstName = '';
  String lastName = '';
  int age = 0;
  String gender = '';
  String tattooDescription = '';
  String tattooSize = ''; // Change tattooSize type to String
  String tattooStyle = '';
  String tattooPlacement = '';
  String? downloadURL;

  final List<String> tattooStyles = [
    'Traditional',
    'Neo-Traditional',
    'Realism',
    'Water-Colour'
  ];

  // List of available tattoo sizes
  final List<String> tattooSizeOptions = [
    'Small (2-3")',
    'Medium (5-7")',
    'Large (9-12")'
  ];

  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pre-consulation Tattoo Form'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Colors.purple],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Text(
                    'InkQuest',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Text('First Name', style: TextStyle(color: Colors.white)),
              TextFormField(
                onChanged: (value) => setState(() => firstName = value),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your first name' : null,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16.0),
              Text('Last Name', style: TextStyle(color: Colors.white)),
              TextFormField(
                onChanged: (value) => setState(() => lastName = value),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your last name' : null,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16.0),
              Text('Age', style: TextStyle(color: Colors.white)),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    setState(() => age = int.tryParse(value) ?? 0),
                validator: (value) => value == null ||
                        int.tryParse(value!) == null ||
                        int.parse(value) <= 0
                    ? 'Please enter a valid age'
                    : null,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16.0),
              Text('Gender', style: TextStyle(color: Colors.white)),
              TextFormField(
                onChanged: (value) => setState(() => gender = value),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your gender' : null,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16.0),
              Text(
                  'Describe your tattoo:                                                       (Include as much detail and as many references as possible.)',
                  style: TextStyle(color: Colors.white)),
              TextFormField(
                onChanged: (value) => setState(() => tattooDescription = value),
                validator: (value) => value!.isEmpty
                    ? 'Please provide a description of your tattoo'
                    : null,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16.0),
              Text('Describe the placement or location of your tattoo:',
                  style: TextStyle(color: Colors.white)),
              TextFormField(
                onChanged: (value) => setState(() => tattooPlacement = value),
                validator: (value) => value!.isEmpty
                    ? 'Please specify the placement of your tattoo'
                    : null,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16.0),
              Text('Size of your tattoo',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: tattooSize.isEmpty ? null : tattooSize,
                onChanged: (value) => setState(() => tattooSize = value!),
                validator: (value) =>
                    value == null ? 'Please select a tattoo size' : null,
                style: TextStyle(color: Colors.white),
                dropdownColor: Colors.purple,
                items: tattooSizeOptions.map((size) {
                  return DropdownMenuItem<String>(
                    value: size,
                    child: Text(size, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              Text("Select your tattoo's Style",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: tattooStyle.isEmpty ? null : tattooStyle,
                onChanged: (value) => setState(() => tattooStyle = value!),
                validator: (value) =>
                    value == null ? 'Please select a tattoo style' : null,
                style: TextStyle(color: Colors.white),
                dropdownColor: Colors.black,
                items: tattooStyles.map((style) {
                  return DropdownMenuItem<String>(
                    value: style,
                    child: Text(style, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              Text('Selected Photo(s):',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white)),
              _selectedImage != null
                  ? Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 16.0),
                      child: Image.file(
                        _selectedImage!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                },
                child: Text('Upload Reference Images'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                },
                child: Text('Take Photo'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> submissionData = {
                      'firstName': firstName,
                      'lastName': lastName,
                      'age': age,
                      'gender': gender,
                      'tattooDescription': tattooDescription,
                      'tattooSize': tattooSize,
                      'tattooStyle': tattooStyle,
                      'tattooPlacement': tattooPlacement,
                      'imageURL': downloadURL
                    };

                    try {
                      DocumentReference submissionRef = await FirebaseFirestore
                          .instance
                          .collection('submissions')
                          .add(submissionData);

                      QuerySnapshot artistSnapshot = await FirebaseFirestore
                          .instance
                          .collection('artists')
                          .where('style', isEqualTo: tattooStyle)
                          .get();

                      // Check if there's at least one artist found
                      if (artistSnapshot.docs.isNotEmpty) {
                        // Get the first artist found
                        Map<String, dynamic> artistData =
                            artistSnapshot.docs.first.data()
                                as Map<String, dynamic>;
                        Artist artist = Artist.fromMap(artistData);

                        // Navigate to the ResultPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultPage(
                              artist: artist,
                              tattooSize: tattooSize,
                            ),
                          ),
                        );
                      } else {
                        // Handle case where no artist is found for the selected style
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'No artist found for the selected style')));
                      }
                    } catch (error) {
                      // Handle any errors that occur during submission or fetching the artist
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $error')));
                    }
                  }
                },
                child: Text('Submit'),
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        FontAwesome.instagram,
                        color: Colors.white,
                        size: 32.0,
                      ),
                    ),
                    SizedBox(width: 16.0),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.facebook,
                        color: Colors.white,
                        size: 32.0,
                      ),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
