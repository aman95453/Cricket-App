import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Import Firestore for testing
import 'match1.dart';
import 'match2.dart';
import 'match3.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Firebase connection test (consider replacing print with logger in production)
  FirebaseFirestore.instance.collection('test').get().then((value) {
  }).catchError((error) {
  });

  runApp(const CricketApp());
}

class CricketApp extends StatelessWidget {
  const CricketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cricket App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
          ),
        ),
        child: Column(
          children: [
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.sports_cricket, color: Colors.white, size: 30),
                    SizedBox(width: 10),
                    Text(
                      'Cricket App',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Expanded(child: MatchList()),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Aman Ullah',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withAlpha(204),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MatchList extends StatelessWidget {
  const MatchList({super.key});

  final List<Map<String, String>> matches = const [
    {
      'team1': 'Pakistan',
      'team2': 'New Zealand',
      'date': '19 Feb 2025',
      'venue': 'National Stadium, Karachi',
      'status': 'Upcoming',
      'matchType': 'Champions Trophy',
      'team1Logo': 'https://flagcdn.com/w320/pk.png',
      'team2Logo': 'https://flagcdn.com/w320/nz.png',
    },
    {
      'team1': 'India',
      'team2': 'Pakistan',
      'date': '23 Feb 2025',
      'venue': 'Dubai Stadium, UAE',
      'status': 'Upcoming',
      'matchType': 'Champions Trophy',
      'team1Logo': 'https://flagcdn.com/w320/in.png',
      'team2Logo': 'https://flagcdn.com/w320/pk.png',
    },
    {
      'team1': 'Bangladesh',
      'team2': 'India',
      'date': '20 Feb 2025',
      'venue': 'Dubai Cricket Stadium, UAE',
      'status': 'Upcoming',
      'matchType': 'Champions Trophy',
      'team1Logo': 'https://flagcdn.com/w320/bd.png',
      'team2Logo': 'https://flagcdn.com/w320/in.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: matches.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final match = matches[index];
        final isLive = match['status'] == 'Live';

        return GestureDetector(
          onTap: () {
            if (match['team1'] == 'Pakistan' && match['team2'] == 'New Zealand') {
              // Navigate to Match3Screen for Pakistan vs New Zealand
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Match3Screen(),
                ),
              );
            } else if (match['team1'] == 'India' && match['team2'] == 'Pakistan') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Match2(), // Updated to Match2
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Match1(), // Updated to Match1
                ),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[900], // Set the card background to grey 900
              borderRadius: BorderRadius.circular(24), // More cornered shape
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withAlpha(100),
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        match['matchType']!,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (isLive)
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(match['team1Logo']!),
                            radius: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            match['team1']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'VS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(match['team2Logo']!),
                            radius: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            match['team2']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: ${match['date']}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Venue: ${match['venue']}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
