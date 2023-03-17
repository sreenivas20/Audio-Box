import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
// import 'package:musicplayer/homepage.dart';

class PlayingScreen extends StatefulWidget {
  PlayingScreen(
      {super.key, required this.songModel, required this.audioPlayer});
  final SongModel songModel;
  final AudioPlayer audioPlayer;
  // static const Color mColor = Color(0x3a376a);
  // static const Color appBarColor = Color.fromARGB(231, 0, 0, 0);

  @override
  State<PlayingScreen> createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<PlayingScreen> {
  // final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = const Duration();
  Duration _position = const Duration();
  // double _currentSliderValue = 50.0;
  bool _isPlaying = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    playSong();
  }

  void playSong() {
    try {
      widget.audioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse(widget.songModel.uri!),
      ));
      widget.audioPlayer.play();
      _isPlaying = true;
    } on Exception {
      log("Cannot parse Song");
    }
    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  void _onFavoriteButtonPress() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _onPlayingButtonPress() {
    setState(() {
      if (_isPlaying) {
        widget.audioPlayer.pause();
      } else {
        widget.audioPlayer.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 10,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.transparent,
        title: const Text('Playing...'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.blueGrey.shade300,
                  Colors.black,
                  Colors.black,
                  Colors.black
                  // Colors.orange
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topRight,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 30,
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.5), BlendMode.dstATop),
                  child: Image.asset(
                    'assets/logo music player.png',
                    width: 300,
                    fit: BoxFit.cover,
                    // scale: 20,
                    // opacity: ,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 125,
            left: 53,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(
                    'assets/logo_music_player-removebg-preview.png',
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 420,
            left: 50,
            child: Text(
              widget.songModel.displayNameWOExt,
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
          Positioned(
            top: 430,
            left: 268,
            child: IconButton(
                onPressed: _onFavoriteButtonPress,
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                  color: Colors.white,
                  // size: ,
                )),
          ),
          Positioned(
            top: 470,
            left: 270,
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.playlist_add,
                  color: Colors.white,
                  size: 30,
                )),
          ),
          Positioned(
            top: 500,
            left: 30,
            child: SizedBox(
              width: 316,
              // height: 200,
              child: Slider.adaptive(
                activeColor: Colors.white,
                inactiveColor: Colors.blueGrey.shade700,
                min: Duration(microseconds: 0).inSeconds.toDouble(),
                value: _position.inSeconds.toDouble(),
                // value: 0.5,
                max: _duration.inSeconds.toDouble(),

                onChanged: (value) {
                  setState(() {
                    changeToSeconds(value.toInt());
                    value = value;
                    // _position = Duration(seconds: value.toInt());
                  });
                },
              ),
            ),
          ),
          Positioned(
            top: 542,
            left: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_position.toString().split(".")[0],
                    style: const TextStyle(fontSize: 10, color: Colors.white)),
                SizedBox(
                  width: 210,
                ),
                Text(_duration.toString().split(".")[0],
                    style: const TextStyle(fontSize: 10, color: Colors.white))
              ],
            ),
          ),
          Positioned(
            top: 560,
            left: 37,
            child: Container(
              width: 288,
              height: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.black),
              child: Row(
                children: [
                  const SizedBox(
                    width: 35,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.skip_previous_outlined,
                        color: Colors.white,
                        size: 38,
                      )),
                  const SizedBox(
                    width: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: IconButton(
                        onPressed: _onPlayingButtonPress,
                        icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: Colors.white,
                          size: 58,
                        )),
                  ),
                  const SizedBox(
                    width: 25,
                    height: 30,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.skip_next_outlined,
                        color: Colors.white,
                        size: 38,
                      )),
                  const SizedBox(
                    width: 12,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.repeat,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }
}
