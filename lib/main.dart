import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const CricketApp());
}

class CricketApp extends StatelessWidget {
  const CricketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cricket App',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue, // Set primary color
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Cricket App',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.blue, // App bar background color
        elevation: 10, // Add shadow
      ),
      body: Container(
        color: Colors.grey[200], // Set background color to light gray
        child: const MatchList(),
      ),
    );
  }
}

class MatchList extends StatelessWidget {
  const MatchList({super.key});

  // Sample match data
  final List<Map<String, String>> matches = const [
    {
      'team1': 'India',
      'team2': 'Australia',
      'date': 'Oct 25, 2023',
      'venue': 'Wankhede Stadium, Mumbai',
    },
    {
      'team1': 'England',
      'team2': 'New Zealand',
      'date': 'Oct 26, 2023',
      'venue': 'Lord\'s, London',
    },
    {
      'team1': 'Pakistan',
      'team2': 'South Africa',
      'date': 'Oct 27, 2023',
      'venue': 'Gaddafi Stadium, Lahore',
    },
    {
      'team1': 'West Indies',
      'team2': 'Sri Lanka',
      'date': 'Oct 28, 2023',
      'venue': 'Kensington Oval, Barbados',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16), // Add padding around the list
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        final isIndiaVsAustralia =
            match['team1'] == 'India' && match['team2'] == 'Australia';

        return Card(
          elevation: 5, // Add shadow to the card
          margin: const EdgeInsets.only(bottom: 16), // Add margin between cards
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(16), // Add padding inside the card
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Match teams
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${match['team1']} vs ${match['team2']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.sports_cricket, color: Colors.blue), // Placeholder for team logo
                  ],
                ),
                const SizedBox(height: 8), // Add spacing
                // Match date
                Text(
                  'Date: ${match['date']}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8), // Add spacing
                // Match venue
                Text(
                  'Venue: ${match['venue']}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                // Watch Live Button (only for India vs Australia)
                if (isIndiaVsAustralia) // Conditionally show the button
                  const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the live match screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LiveMatchScreen(),
                      ),
                    );
                  },
                  child: const Text('Watch Live'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LiveMatchScreen extends StatefulWidget {
  const LiveMatchScreen({super.key});

  @override
  State<LiveMatchScreen> createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends State<LiveMatchScreen> {
  late VideoPlayerController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Use VideoPlayerController.networkUrl instead of VideoPlayerController.network
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8'), // Replace with your live stream URL
    )..initialize().then((_) {
      setState(() {
        _isLoading = false;
      });
      _controller.play(); // Start playing the video
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load live stream')),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the screen is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Match - India vs Australia'),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller), // Display the video player
      ),
    );
  }
}