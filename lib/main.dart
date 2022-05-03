import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Walkman Application',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: MusicApp(),
    );
  }
}

class MusicApp extends StatefulWidget {
  MusicApp({Key? key}) : super(key: key);

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  bool playing = false;
  IconData playBtn = Icons.play_arrow;

  late AudioPlayer _player;
  late AudioCache cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  Widget slider() {
    return Container(
      width: 300.0,
      child: Slider.adaptive(
          activeColor: Colors.blue.shade800,
          inactiveColor: Colors.grey.shade700,
          value: position.inSeconds.toDouble(),
          max: musicLength.inSeconds.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);

    // _player.durationHandler = (d) {
    //   setState(() {
    //     musicLength = d;
    //   });
    // };

    // _player.positionHandler = (p) {
    //   setState(() {
    //     position = p;
    //   });
    // };

    _player.onDurationChanged.listen((d) => setState(() => musicLength = d));

    _player.onAudioPositionChanged.listen((p) => setState(() => position = p));

    cache.load("middle_of_the_night.mp3");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue,
                Colors.green,
              ]),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 48.0,
          ),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                  ),
                  child: Text(
                    "Walkman",
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                  ),
                  child: Text(
                    "Listen to your favorite Music",
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Center(
                  child: Container(
                    width: 250.0,
                    height: 300.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      image: DecorationImage(
                        image: AssetImage("assets/cover.jpg"),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Center(
                  child: Text(
                    "Middle of the Night",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 179, 255, 247),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 500.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${position.inMinutes}: ${position.inSeconds.remainder(60)}",
                                    style: TextStyle(
                                      fontSize: 10.0,
                                    ),
                                  ),
                                  slider(),
                                  Text(
                                    "${musicLength.inMinutes}: ${musicLength.inSeconds.remainder(60)}",
                                    style: TextStyle(
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  iconSize: 45.0,
                                  color: Colors.teal.shade800,
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.skip_previous,
                                  ),
                                ),
                                IconButton(
                                  iconSize: 62.0,
                                  color: Colors.teal.shade800,
                                  onPressed: () {
                                    if (!playing) {
                                      cache.play("middle_of_the_night.mp3");
                                      setState(() {
                                        playBtn = Icons.pause;
                                        playing = true;
                                      });
                                    } else {
                                      _player.pause();
                                      setState(() {
                                        playBtn = Icons.play_arrow;
                                        playing = false;
                                      });
                                    }
                                  },
                                  icon: Icon(playBtn),
                                ),
                                IconButton(
                                  iconSize: 45.0,
                                  color: Colors.teal.shade800,
                                  onPressed: () {},
                                  icon: Icon(Icons.skip_next),
                                )
                              ],
                            )
                          ],
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
