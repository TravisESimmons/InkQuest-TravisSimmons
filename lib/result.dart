import 'package:flutter/material.dart';
import 'package:inkquest_travissimmons/models/artist.dart';
import 'models/artist.dart';

class ResultPage extends StatelessWidget {
  final Artist artist;
  final String tattooSize;

  const ResultPage({
    Key? key,
    required this.artist,
    required this.tattooSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate estimated tattoo cost based on tattoo size and artist rate
    int estimatedCost = calculateEstimatedCost();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tattoo Result'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Best Artist for ${artist.style} Style:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                artist.name,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Estimated Tattoo Cost:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '\$$estimatedCost',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Your artist will be in touch shortly.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to calculate estimated tattoo cost based on tattoo size and artist rate
  int calculateEstimatedCost() {
    int rateMultiplier = 0;
    switch (tattooSize.toLowerCase()) {
      case 'small':
        rateMultiplier = 3;
        break;
      case 'medium':
        rateMultiplier = 7;
        break;
      case 'large':
        rateMultiplier = 11;
        break;
    }
    return rateMultiplier * artist.rate;
  }
}
