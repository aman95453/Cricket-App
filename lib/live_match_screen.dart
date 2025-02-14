import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';

class LiveMatchScreen extends StatefulWidget {
  const LiveMatchScreen({Key? key}) : super(key: key);

  @override
  State<LiveMatchScreen> createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends State<LiveMatchScreen> {
  late BetterPlayerController _betterPlayerController;
  bool _isLoading = true;
  bool _isPlaying = true;
  double _volume = 50;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    try {
      // Initialize the BetterPlayer controller
      _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          autoPlay: true,
          controlsConfiguration: const BetterPlayerControlsConfiguration(
            showControlsOnInitialize: false,
          ),
          aspectRatio: 16 / 9,
          allowedScreenSleep: false,
          fullScreenByDefault: false,
        ),
        betterPlayerDataSource: BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', // Direct MP4 stream
        ),
      );

      // Listen for player initialization
      _betterPlayerController.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
          print('Player initialized successfully');
          setState(() {
            _isLoading = false;
          });
        }
        if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
          final errorDescription = event.parameters?['errorDescription'] ?? 'Unknown error';
          print('Player error: $errorDescription');
          setState(() {
            _errorMessage = errorDescription;
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      print('Failed to initialize player: $e');
      setState(() {
        _errorMessage = 'Failed to initialize player: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _togglePlayPause() {
    final isPlaying = _betterPlayerController.isPlaying();
    if (isPlaying == true) { // Explicitly check for `true`
      _betterPlayerController.pause();
    } else {
      _betterPlayerController.play();
    }
    setState(() {
      _isPlaying = isPlaying ?? false; // Use `false` as a fallback if `isPlaying` is `null`
    });
  }

  void _setVolume(double value) {
    _betterPlayerController.setVolume(value);
    setState(() {
      _volume = value;
    });
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Match'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: () {
              // Enter full-screen mode
              _betterPlayerController.enterFullScreen();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
        child: Text(
          'Error: $_errorMessage',
          style: const TextStyle(color: Colors.red),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: BetterPlayer(
              controller: _betterPlayerController,
            ),
          ),
          // Playback controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _togglePlayPause,
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              ),
              Slider(
                value: _volume,
                min: 0,
                max: 100,
                onChanged: _setVolume,
              ),
            ],
          ),
        ],
      ),
    );
  }
}