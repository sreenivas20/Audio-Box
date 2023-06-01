import 'package:flutter/material.dart';
import 'package:musicplayer/db_funtion/all_db_functions.dart';
import 'package:musicplayer/db_funtion/mostlyplayed.dart';
import 'package:musicplayer/db_funtion/songdb_model.dart';
import 'package:musicplayer/screen/bottamnavigationbar.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SplashScreenProvider extends ChangeNotifier{

 final _audioQuery = new OnAudioQuery();
  // final AudioPlayer _audioPlayer = AudioPlayer();
  final box = SongBox.getInstance();
  List<SongModel> songsFetched = [];
  List<SongModel> allSong = [];

  requestStoragePermission(BuildContext context) async {
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

}