import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/db_funtion/mostlyplayed.dart';
import 'package:musicplayer/db_funtion/songdb_model.dart';
import 'package:musicplayer/screen/bottamnavigationbar.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:musicplayer/db_funtion/all_db_functions.dart';
// import 'package:musicplayer/bottamnavigationbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
  // final mostbox = MostPlayedBox.getInstance();

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }

  final _audioQuery = new OnAudioQuery();
  // final AudioPlayer _audioPlayer = AudioPlayer();
  final box = SongBox.getInstance();
  List<SongModel> songsFetched = [];
  List<SongModel> allSong = [];

  requestStoragePermission() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();

      songsFetched = await _audioQuery.querySongs();
      for (var element in songsFetched) {
        if (element.fileExtension == "mp3") {
          allSong.add(element);
        }
      }

      for (var element in allSong) {
        mostPlayedSongs.add(MostPlayed(
            songname: element.title,
            songurl: element.uri!,
            duration: element.duration!,
            artist: element.artist!,
            count: 0,
            id: element.id));
      }

      for (var element in allSong) {
        await box.add(Songs(
            songname: element.title,
            artist: element.artist,
            duration: element.duration,
            songUrl: element.uri,
            id: element.id));
      }
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (contex) => const BottamNavigationScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A376A),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueGrey.shade300,
              Colors.black,
              Colors.black,
              Colors.black
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              'assets/logo_music_player-removebg-preview.png',
              width: 330,
            ),
          ),
        ),
      ),
    );
  }
}
