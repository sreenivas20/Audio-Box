import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/db_funtion/mostlyplayed.dart';

class MostlyPlayedProvider extends ChangeNotifier {
  final List<Audio> _songs = [];
  List<Audio> get songs => _songs;
  final List<MostPlayed> _mostfinalsong = [];
  List<MostPlayed> get mostfinalsong => _mostfinalsong;
  List<MostPlayed> _songlist = [];
  List<MostPlayed> get songlist => _songlist;

  void mostlyPlayer() {
    final box = MostPlayedBox.getInstance();
    _songlist = box.values.toList();

    _mostfinalsong.clear();
    int i = 0;
    for (var item in _songlist) {
      if (item.count > 3) {
        _mostfinalsong.insert(i, item);
        i++;
      }
    }

    for (var item in _mostfinalsong) {
      _songs.add(Audio.file(item.songurl,
          metas: Metas(
              title: item.songname,
              artist: item.artist,
              id: item.id.toString())));
    }
    notifyListeners();
  }
}
