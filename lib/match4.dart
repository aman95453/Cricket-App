import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class Match4 extends StatefulWidget {
  const Match4({super.key, required Map<String, dynamic> matchData});

  @override
  State<Match4> createState() => _Match4State();
}

class _Match4State extends State<Match4> {
  BetterPlayerController? _betterPlayerController;
  bool _isLoading = true;
  List<String> streamUrls = [];
  int currentStreamIndex = 0;
  bool _showStreamButtons = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WakelockPlus.enable();
    fetchStreamUrls();
  }

  Future<void> fetchStreamUrls() async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance.collection('live4').doc('match').get();
      if (document.exists && document.data() != null) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        if (data.containsKey('streams')) {
          streamUrls = List<String>.from(data['streams']);
          if (kDebugMode) {
            debugPrint('Stream URLs fetched: $streamUrls');
          }
          if (streamUrls.isNotEmpty) {
            setupPlayer(streamUrls[currentStreamIndex]);
          } else {
            showError('No streams available.');
          }
        } else {
          showError('Streams field not found.');
        }
      } else {
        showError('Stream not found.');
      }
    } catch (e) {
      showError('Error fetching streams.');
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

  void switchStream(int index) {
    if (index < 0 || index >= streamUrls.length) return;
    setState(() {
      _isLoading = true;
      currentStreamIndex = index;
    });
    _betterPlayerController?.dispose();
    setupPlayer(streamUrls[index]);
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

  void toggleStreamButtonsVisibility() {
    if (kDebugMode) {
      debugPrint('Toggling stream buttons visibility');
    }
    setState(() {
      _showStreamButtons = !_showStreamButtons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: toggleStreamButtonsVisibility,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // Video Player
            Column(
              children: [
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : BetterPlayer(controller: _betterPlayerController!),
                ),
              ],
            ),

            if (_showStreamButtons && streamUrls.isNotEmpty)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(streamUrls.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.0),
                          child: ElevatedButton(
                            onPressed: () => switchStream(index),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: const Size(70, 27),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              elevation: 0,
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blueAccent,
                                    Colors.purpleAccent,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Text(
                                  'Stream ${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    WakelockPlus.disable();
    _betterPlayerController?.dispose();
    super.dispose();
  }
}