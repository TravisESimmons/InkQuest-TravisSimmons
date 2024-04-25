import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inkquest_travissimmons/models/artist.dart';
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
                // Construct the submission object with the form data
                Map<String, dynamic> submissionData = {
                  'firstName': firstName,
                  'lastName': lastName,
                  'age': age,
                  'gender': gender,
                  'tattooDescription': tattooDescription,
                  'tattooSize': tattooSize,
                  'tattooStyle': tattooStyle,
                  'tattooPlacement': tattooPlacement,
                  // You may need to add more fields or modify the structure based on your requirements
                };

                try {
                  // Add the submission to the "submissions" collection in Firestore
                  DocumentReference submissionRef = await FirebaseFirestore
                      .instance
                      .collection('submissions')
                      .add(submissionData);

                  // Fetch the artist based on the selected tattoo style
                  QuerySnapshot artistSnapshot = await FirebaseFirestore
                      .instance
                      .collection('artists')
                      .where('style', isEqualTo: tattooStyle)
                      .get();

                  // Check if there's at least one artist found
                  if (artistSnapshot.docs.isNotEmpty) {
                    // Get the first artist found (you may need to handle multiple artists differently)
                    Map<String, dynamic> artistData = artistSnapshot.docs.first
                        .data() as Map<String, dynamic>;
                    Artist artist = Artist.fromMap(artistData);

                    // Navigate to the ResultPage with the retrieved artist
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
                        content:
                            Text('No artist found for the selected style')));
                  }
                } catch (error) {
                  // Handle any errors that occur during submission or fetching the artist
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error: $error')));
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
