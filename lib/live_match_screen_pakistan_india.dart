import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveMatchScreenPakistanIndia extends StatefulWidget {
  const LiveMatchScreenPakistanIndia({Key? key}) : super(key: key);

  @override
  State<LiveMatchScreenPakistanIndia> createState() => _LiveMatchScreenPakistanIndiaState();
}

class _LiveMatchScreenPakistanIndiaState extends State<LiveMatchScreenPakistanIndia> {
  BetterPlayerController? _betterPlayerController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    fetchStreamUrl();
  }

  Future<void> fetchStreamUrl() async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance.collection('live').doc('match2').get();
      if (document.exists && document.data() != null) {
        String url = document['url'];
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
      expandToFill: true,
      deviceOrientationsOnFullScreen: [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
      allowedScreenSleep: false,
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
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _betterPlayerController != null
          ? BetterPlayer(controller: _betterPlayerController!)
          : const Center(child: Text("No video available")),
    );
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }
}
