import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/db_funtion/songdb_model.dart';
import 'package:musicplayer/screen/playingscreen.dart';

class SearchProvider extends ChangeNotifier {
  List<Audio> allSongs = [];
  List<Songs> dbSongs = [];
  late List<Songs> anotherList = List.from(dbSongs);

  void initStateFuntion() {
    dbSongs = box.values.toList();
    for (var element in dbSongs) {
      allSongs.add(Audio.file(element.songUrl!,
          metas: Metas(
              title: element.songname,
              artist: element.artist,
              id: element.id.toString())));
    }
  }

  void searchList(String value) {
    anotherList = dbSongs
        .where((element) =>
            element.songname!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    allSongs.clear();
    for (var item in anotherList) {
      allSongs.add(
        Audio.file(
          item.songUrl.toString(),
          metas: Metas(
            artist: item.artist,
            title: item.songname,
            id: item.id.toString(),
          ),
        ),
      );
    }
    notifyListeners();
  }
}
