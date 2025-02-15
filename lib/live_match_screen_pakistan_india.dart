import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/services.dart';

class LiveMatchScreenPakistanIndia extends StatefulWidget {
  const LiveMatchScreenPakistanIndia({Key? key}) : super(key: key);

  @override
  State<LiveMatchScreenPakistanIndia> createState() => _LiveMatchScreenPakistanIndiaState();
}

class _LiveMatchScreenPakistanIndiaState extends State<LiveMatchScreenPakistanIndia> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    BetterPlayerConfiguration betterPlayerConfiguration = BetterPlayerConfiguration(
      fit: BoxFit.fill,
      autoPlay: true,
      looping: false,
      expandToFill: true,
      deviceOrientationsOnFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
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
      'https://mut1.mylife1.top:8088/live/webcricu19/playlist.m3u8?vidictid=201349344524&id=115680&pk=d17cea96af0731f9c2b883bd5bd0d75a0deebed24cbb21b4ef64136b7beefa450feb9c38c8406e3b75059d0695869b9ab9102483c4724e2eae580032a2302fc1',
      videoFormat: BetterPlayerVideoFormat.hls,
    );

    _betterPlayerController = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: dataSource,
    );
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BetterPlayer(controller: _betterPlayerController),
    );
  }
}
