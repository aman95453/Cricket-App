import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveMatchScreen extends StatefulWidget {
  const LiveMatchScreen({super.key});

  @override
  State<LiveMatchScreen> createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends State<LiveMatchScreen> {
  BetterPlayerController? _betterPlayerController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    fetchStreamUrl();
  }

  Future<void> fetchStreamUrl() async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance.collection('live').doc('match').get();
      if (document.exists && document.data() != null) {
        String url = (document.data() as Map<String, dynamic>)['url'];
        if (!mounted) return;
        setupPlayer(url);
      } else {
        showError('Stream not found.');
      }
    } catch (e) {
      showError('Error fetching stream URL.');
    }
  }

  void setupPlayer(String url) {
    BetterPlayerConfiguration betterPlayerConfiguration = BetterPlayerConfiguration(
      fit: BoxFit.fill,
      autoPlay: true,
      looping: false,
      allowedScreenSleep: false,
      expandToFill: true,
      aspectRatio: 16 / 9,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        backgroundColor: Colors.black,
        controlBarColor: Colors.transparent,
        enableSubtitles: true,
        enableQualities: true,
        enablePlaybackSpeed: true,
        showControls: true,
        playerTheme: BetterPlayerTheme.material,
      ),
    );

    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
      videoFormat: BetterPlayerVideoFormat.hls,
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController!.setupDataSource(dataSource).then((_) {
      if (mounted) setState(() => _isLoading = false);
    }).catchError((error) {
      showError('Failed to load video.');
    });
  }

  void showError(String message) {
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _betterPlayerController != null
          ? BetterPlayer(controller: _betterPlayerController!)
          : const Center(child: Text("No video available")),
      backgroundColor: Colors.black,
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _betterPlayerController?.dispose();
    super.dispose();
  }
}
