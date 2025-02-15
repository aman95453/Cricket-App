import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'live_match_screen.dart';

void main() {
  runApp(const CricketApp());
}

class CricketApp extends StatelessWidget {
  const CricketApp({Key? key}) : super(key: key);

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
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set immersive UI
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
            // App logo and title
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

            // Match List
            const Expanded(child: MatchList()),
          ],
        ),
      ),
    );
  }
}

class MatchList extends StatelessWidget {
  const MatchList({Key? key}) : super(key: key);

  // Sample match data
  final List<Map<String, String>> matches = const [
    {
      'team1': 'Australia',
      'team2': 'Sri Lanka',
      'date': '16 Feb 2025',
      'venue': 'B. Damadesa Stadium, Colombo',
      'status': 'Live',
      'matchType': '3rd Test',
      'team1Logo': 'https://flagcdn.com/w320/au.png',
      'team2Logo': 'https://flagcdn.com/w320/lk.png',
    },
    {
      'team1': 'India',
      'team2': 'Pakistan',
      'date': '23 Feb 2025',
      'venue': 'Dubai Stadium, Uae',
      'status': 'Upcoming',
      'matchType': 'Champions Trophy',
      'team1Logo': 'https://flagcdn.com/w320/in.png',
      'team2Logo': 'https://flagcdn.com/w320/pk.png',
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LiveMatchScreen(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(128, 0, 0, 0), // 128 is 50% opacity
                  // 128 is 50% opacity in 0-255 scale

                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Stack(
              children: [
                // Match Info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Match Type and Live Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            match['matchType']!,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (isLive)
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
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
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Team Logos and Names
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Team 1
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(match['team1Logo']!),
                                radius: 30,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                match['team1']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          // VS Text
                          const Text(
                            'VS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),

                          // Team 2
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(match['team2Logo']!),
                                radius: 30,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                match['team2']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Date and Venue
                      Text(
                        'Date: ${match['date']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Venue: ${match['venue']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                // Tap Indicator
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 10,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Tap to Watch',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}