import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late AudioPlayer player;
  late Duration duration;
  late Duration position;
  final uri = Uri.parse(
      'https://t2.genius.com/unsafe/425x425/https%3A%2F%2Fimages.genius.com%2Fda1f2f0b57e6ab9318786b28a632a607.1000x1000x1.png');
  bool isPlaying = false;
  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    duration = Duration.zero;
    position = Duration.zero;
    player.onDurationChanged.listen(
      (newDuration) {
        setState(() {
          duration = newDuration;
        });
      },
    );
    player.onPositionChanged.listen(
      (newPosition) {
        setState(() {
          position = newPosition;
        });
      },
    );
    player.onPlayerComplete.listen(
      (events) {
        setState(() {
          isPlaying = false;
          duration = Duration.zero;
        });
      },
    );
  }

  void despose() {
    super.dispose();
    player.dispose();
  }

  void playPause() async {
    if (isPlaying) {
      await player.pause();
    } else {
      await player.play(AssetSource('audio/Я хочу тебя трахать.mp3'));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter demo',
      theme: ThemeData(),
      home: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 247, 150, 143), // Верхний цвет
                  Colors.white, // Нижний цвет
                ],
                stops: [
                  0.6,
                  0.2
                ], // Переход между цветами происходит на середине
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://t2.genius.com/unsafe/425x425/https%3A%2F%2Fimages.genius.com%2Fda1f2f0b57e6ab9318786b28a632a607.1000x1000x1.png',
                  width: 350,
                  height: 350,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formatDuration(
                          position,
                        ),
                        style: const TextStyle(fontSize: 25),
                      ),
                      IconButton(
                        onPressed: () {
                          playPause();
                        },
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 40,
                        ),
                      ),
                      if (duration > Duration.zero)
                        Expanded(
                          child: Slider(
                            value: position.inSeconds
                                .clamp(0, duration.inSeconds)
                                .toDouble(),
                            max: duration.inSeconds.toDouble(),
                            label: formatDuration(position),
                            onChanged: (value) async {
                              final newPosition =
                                  Duration(seconds: value.toInt());
                              await player.seek(newPosition);
                              setState(() {
                                position = newPosition;
                              });
                            },
                          ),
                        ),
                      Text(
                        formatDuration(
                          duration,
                        ),
                        style: const TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
