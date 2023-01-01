import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class NowPlaying extends StatefulWidget {
  NowPlaying(
      {super.key,
      required this.audioPlayer,
      required this.songModel,
      required this.songsList,
      required this.currentIndex});
  final SongModel songModel;
  late final songsList;
  final currentIndex;

  AudioPlayer audioPlayer;
  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  // ignore: unused_field
  late AnimationController _controller;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _isplaying = false;
  Color _iconColor = Colors.grey;
  Color _repeat = Colors.grey;
  int _currentIndex = 0;

  @override
  void initState() {
    playSong();
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void playSong() {
    try {
      widget.audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(widget.songModel.uri!),
        ),
      );
      // ignore: avoid_print
      widget.audioPlayer.play();
      _isplaying = true;
    } on Exception {
      // ignore: avoid_print
      print('Error pasing song');
    }
    widget.audioPlayer.durationStream.listen(
      (d1) {
        setState(
          () {
            _duration = d1!;
          },
        );
      },
    );
    widget.audioPlayer.positionStream.listen(
      (p1) {
        setState(
          () {
            _position = p1;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 70),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 100,
                      child: Icon(
                        Icons.music_note_rounded,
                        color: Colors.green,
                        size: 80,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      widget.songsList[_currentIndex].title,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          color: Color.fromARGB(255, 225, 216, 216)),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        widget.songsList[widget.currentIndex].artist,
                        semanticsLabel: toString() == "<unknown>"
                            ? 'Unknown Artist'
                            : widget.songsList[widget.currentIndex].artist.toString(),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 130,
              ),
              Row(
                children: [
                  Text(
                    _position.toString().split('.')[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                  Expanded(
                    child: Slider(
                      thumbColor: const Color.fromARGB(255, 19, 244, 98),
                      activeColor: const Color.fromARGB(255, 90, 237, 61),
                      inactiveColor: const Color.fromARGB(255, 255, 255, 255),
                      min: const Duration(microseconds: 0).inSeconds.toDouble(),
                      value: _position.inSeconds.toDouble(),
                      max: _duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        setState(
                          () {
                            onChanged(value.toInt());
                            value = value;
                          },
                        );
                      },
                    ),
                  ),
                  Text(
                    _duration.toString().split('.')[0],
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      goBackward();
                    },
                    icon: const Icon(
                      Icons.fast_rewind_outlined,
                      size: 35,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      prev();
                    },
                    icon: const Icon(
                      Icons.skip_previous_outlined,
                      size: 40,
                      color: Color.fromARGB(255, 79, 219, 84),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(
                        () {
                          if (_isplaying) {
                            widget.audioPlayer.pause();
                          } else {
                            widget.audioPlayer.play();
                          }
                          _isplaying = !_isplaying;
                        },
                      );
                    },
                    icon: Icon(
                      _isplaying ? Icons.pause : Icons.play_arrow,
                      size: 40.0,
                      color: const Color.fromARGB(255, 253, 255, 252),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      next();
                    },
                    icon: const Icon(
                      Icons.skip_next_outlined,
                      size: 40,
                      color: Color.fromARGB(255, 79, 219, 84),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      goForward();
                    },
                    icon: const Icon(
                      Icons.fast_forward_outlined,
                      size: 35,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
              //-----------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(
                        () {
                          if (_iconColor == Colors.grey) {
                            _iconColor = Colors.red;
                          } else {
                            _iconColor = Colors.grey;
                          }
                        },
                      );
                    },
                    icon: Icon(
                      Icons.favorite_outline_rounded,
                      color: _iconColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_repeat == Colors.grey) {
                          _repeat = const Color.fromARGB(255, 31, 169, 255);
                          playLoop();
                        } else {
                          _repeat = Colors.grey;
                          playLoopStop();
                        }
                      });
                    },
                    icon: Icon(
                      Icons.repeat_one_rounded,
                      color: _repeat,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //------------------Slider--duration---------
  void onChanged(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }

//---------------goForward---------------
  void goForward() async {
    await widget.audioPlayer.seek(
      Duration(
        seconds: widget.audioPlayer.position.inSeconds + 5,
      ),
    );
  }

//--------------------------------------
//---------------goBackward-------------
  void goBackward() {
    widget.audioPlayer.seek(
      Duration(
        seconds: widget.audioPlayer.position.inSeconds - 5,
      ),
    );
  }

  //--------repeat--song----------------
  Future<void> playLoop() async {
    await widget.audioPlayer.setLoopMode(LoopMode.one);
  }

  Future<void> playLoopStop() async {
    await widget.audioPlayer.setLoopMode(LoopMode.off);
  }

//-----------next-song-----------
  void next() async {
    setState(() async {
      int songsLength = widget.songsList.length;

      _currentIndex = (_currentIndex + 1) % songsLength;

      var selectedSong = widget.songsList[_currentIndex].data;

      await widget.audioPlayer.setUrl(selectedSong);
    });
  }

//-----------previous-song-----------
  void prev() {
    setState(() async {
      int songsLength = widget.songsList.length;

      _currentIndex = (_currentIndex - 1) % songsLength;

      var selectedSong = widget.songsList[_currentIndex].data;

      await widget.audioPlayer.setUrl(selectedSong);
    });
  }
}
