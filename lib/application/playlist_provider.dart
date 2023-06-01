import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/db_funtion/playlistmodel.dart';
import 'package:musicplayer/db_funtion/songdb_model.dart';

class PlayListProvider extends ChangeNotifier {
  List<PlaylistSongs> playList = [];
  List<PlaylistSongs> _playListSong = [];
  List<PlaylistSongs> get playListSong => _playListSong;
  List<Songs> _playSong = [];
  List<Songs> get playSong => _playSong;

  void playListFunction() {
    playList = PlaylistSongsbox.getInstance().values.toList();
    notifyListeners();
  }

  // void addSongs(int index, List<PlaylistSongs> playlistsongs, int songindex,
  //     List<PlaylistSongs> playlistsong) {
  //   final songbox = SongBox.getInstance();
  //   PlaylistSongs playsongs = playlistsongs[index];
  //   List<Songs> playsongdb = playsongs.playlistsongs!;
  //   List<Songs> songdb = songbox.values.toList();
  //   bool isAddedAlready =
  //       playsongdb.any((element) => element.id == songdb[songindex].id);

  //   if (!isAddedAlready) {
  //     playsongdb.add(
  //       Songs(
  //         songname: songdb[songindex].songname,
  //         artist: songdb[songindex].artist,
  //         duration: songdb[songindex].duration,
  //         songUrl: songdb[songindex].songUrl,
  //         id: songdb[songindex].id,
  //       ),
  //     );
  //   }

  //   playlistsongs[index] = PlaylistSongs(
  //     platlistname: playlistsong[index].platlistname,
  //     playlistsongs: playsongdb,
  //   );

  //   notifyListeners();
  // }

  void displaySongs(index) {
    final playListBox = PlaylistSongsbox.getInstance();
    _playListSong = playListBox.values.toList();
    _playSong = _playListSong[index].playlistsongs!;
    notifyListeners();
  }

  List<Audio> _convertAudios = [];
  List<Audio> get convertAudios => _convertAudios;
  void playlistconvert(playindex) {
    _convertAudios.clear();
    final playbox = PlaylistSongsbox.getInstance();
    List<PlaylistSongs> playlistsongs = playbox.values.toList();
    for (var item in playlistsongs[playindex].playlistsongs!) {
      _convertAudios.add(
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
    notifyListeners();
  }
}
