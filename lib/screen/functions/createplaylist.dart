import 'package:musicplayer/db_funtion/playlistmodel.dart';
import 'package:musicplayer/db_funtion/songdb_model.dart';

createplaylist(String name) async {
  final box1 = PlaylistSongsbox.getInstance();

  List<Songs> songsplaylist = [];
  box1.add(PlaylistSongs(platlistname: name, playlistsongs: songsplaylist));
}

editPlayList(String name, index) async {
  final playlistbox = PlaylistSongsbox.getInstance();
  List<PlaylistSongs> playlistsongs = playlistbox.values.toList();
  final box1 = PlaylistSongsbox.getInstance();

  box1.putAt(
      index,
      PlaylistSongs(
          platlistname: name,
          playlistsongs: playlistsongs[index].playlistsongs));
}

deletePlaylist(int index) {
  final box1 = PlaylistSongsbox.getInstance();

  box1.deleteAt(index);
}
