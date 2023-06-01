import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/db_funtion/favorate_db_model.dart';

class FavoritePageProvider extends ChangeNotifier {
  final List<Favourites> favourite = [];
  final box = FavSongBox.getInstance();
  late List<Favourites> favouritesongs = box.values.toList();
  bool isalready = true;
  List<Audio> favSongs = [];
  List<Favourites> _favouritesongs1 = [];

  List<Favourites> get favouritesongs1 => _favouritesongs1;

  void initStateProviderFav() {
    _favouritesongs1 = box.values.toList().reversed.toList();
    favSongs.clear();
    for (var element in favouritesongs1) {
      favSongs.add(
        Audio.file(
          element.songUrl.toString(),
          metas: Metas(
            artist: element.artist,
            title: element.songname,
            id: element.id.toString(),
          ),
        ),
      );
    }
    notifyListeners();
  }
}
