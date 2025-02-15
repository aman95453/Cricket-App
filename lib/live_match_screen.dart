import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/services.dart';

class LiveMatchScreen extends StatefulWidget {
  const LiveMatchScreen({Key? key}) : super(key: key);

  @override
  State<LiveMatchScreen> createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends State<LiveMatchScreen> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // Hide notification bar during video playback

    BetterPlayerConfiguration betterPlayerConfiguration = BetterPlayerConfiguration(
      fit: BoxFit.fill, // Maintain 16:9 aspect ratio in portrait
      autoPlay: true,
      looping: false,
      fullScreenByDefault: false,
      allowedScreenSleep: false,
      expandToFill: true,
      aspectRatio: 16 / 9, // Set 16:9 aspect ratio for portrait
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
      "https://muc2.mylife1.top:8088/live/webcricm05/playlist.m3u8?vidictid=201344412598&id=114516&pk=d17cea96af0731f9c2b883bd5bd0d75a0deebed24cbb21b4ef64136b7beefa450feb9c38c8406e3b75059d0695869b9ab9102483c4724e2eae580032a2302fc1",
      videoFormat: BetterPlayerVideoFormat.hls,
    );

    _betterPlayerController = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: dataSource,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BetterPlayer(controller: _betterPlayerController),
      backgroundColor: Colors.black,
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); // Restore system UI after playback
    _betterPlayerController.dispose();
    super.dispose();
  }
}
