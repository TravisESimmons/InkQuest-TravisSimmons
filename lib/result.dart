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
      appBar:
          AppBar(title: Text('Tattoo Result'), backgroundColor: Colors.white),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Colors.purple],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'InkQuest',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'The Best Artist for ${artist.style} Style:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  artist.name,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Estimated Tattoo Cost:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '\$$estimatedCost',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Your artist will be in touch shortly.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to calculate estimated tattoo cost based on tattoo size and artist rate
  int calculateEstimatedCost() {
    int rateMultiplier = 0;
    print('tattooSize passed: $tattooSize');
    switch (tattooSize.toLowerCase()) {
      case 'small (2-3")':
        rateMultiplier = 3;
        break;
      case 'medium (5-7")':
        rateMultiplier = 7;
        break;
      case 'large (9-12")':
        rateMultiplier = 11;
        break;
      default:
        print('No match found for size');
        break;
    }
    print('Rate Multiplier: $rateMultiplier, Artist Rate: ${artist.rate}');
    return rateMultiplier * artist.rate;
  }
}
