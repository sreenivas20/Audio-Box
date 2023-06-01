import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/db_funtion/songdb_model.dart';


class HomeScreenProvider extends ChangeNotifier {
  static List<Audio> convertedAudios = [];
  final songbox = SongBox.getInstance();

  void initFunction() {
    List<Songs> dbsongs = songbox.values.toList();
    for (var item in dbsongs) {
      convertedAudios.add(
        Audio.file(
          item.songUrl!,
          metas: Metas(
            title: item.songname,
            artist: item.artist,
            id: item.id.toString(),
          ),
        ),
      );
    }
  }
   static final  songbox1 = SongBox.getInstance();
    List<Songs> dbSongs = songbox1.values.toList();
  
}
