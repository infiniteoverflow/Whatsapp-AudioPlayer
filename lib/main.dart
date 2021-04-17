import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Whatsapp Audio Player'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String audioUrl = "<Audio-link>";

  AudioPlayer audioPlayer = AudioPlayer();
  Duration totalDuration;
  Duration newTiming;

  bool playing = false;

  initAudio() {
    print("Audio Initialized");
    audioPlayer.play(audioUrl);
    audioPlayer.getDuration().then((value) {
      print(value);
    });
    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        newTiming = event;
      });
    });
    audioPlayer.onDurationChanged.listen((updatedDuration) {
      totalDuration = updatedDuration;
    });
  }

  pauseAudio() {
    audioPlayer.pause();
  }

  stopAudio() {
    audioPlayer.stop();
  }

  seekAudio(Duration durationToSeek){
    audioPlayer.seek(durationToSeek);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green[900],
      ),
      body: Center(
        child: Container(
          height: 90,
          width: MediaQuery.of(context).size.width / 1.2,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Center(
                    child: Text(
                      "Ravi"[0].toUpperCase(),
                    ),
                  ),
                ),
                (playing == true)? IconButton(
                  icon: Icon(
                    Icons.pause,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () {
                    pauseAudio();
                    setState(() {
                      playing = !playing;
                    });
                  },
                ) : IconButton(
                  icon: Icon(
                    Icons.play_arrow_sharp,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () {
                    if(newTiming.toString() == "null") initAudio();
                    else audioPlayer.resume();
                    setState(() {
                      playing = !playing;
                    });
                  },
                ),
                Expanded(
                  child: Container(
                    height: 70,
                    child: Stack(
                      children: [
                        Slider(
                          value: newTiming==null? 0 : newTiming.inMilliseconds.toDouble(),
                          min: 0,
                          max: totalDuration==null? 20 : totalDuration.inMilliseconds.toDouble() ,
                          onChanged: (value) {
                            setState(() {
                              seekAudio(Duration(milliseconds: value.toInt()));
                            });
                          },
                        ),
                        Positioned(
                          bottom:3,
                          left: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                (newTiming.toString() == "null")? "0:00:00" : newTiming.toString().split('.').first,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
