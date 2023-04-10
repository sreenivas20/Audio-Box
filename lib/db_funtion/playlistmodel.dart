import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer/db_funtion/songdb_model.dart';
part 'playlistmodel.g.dart';
@HiveType(typeId: 2)
class PlaylistSongs {
  @HiveField(0)
  String? platlistname;

  @HiveField(1)
  List<Songs>? playlistsongs;

  PlaylistSongs({required this.platlistname, required this.playlistsongs});
}

class PlaylistSongsbox {
  static Box<PlaylistSongs>? _box;
  static Box<PlaylistSongs> getInstance() {
    return _box ??= Hive.box('playlist');
  }
}
