

import 'package:flutter/material.dart';
import 'package:musicplayer/db_funtion/playlistmodel.dart';
import 'package:musicplayer/db_funtion/songdb_model.dart';

createplaylist(
  String name,
  context,
) async {
  final box1 = PlaylistSongsbox.getInstance();

  List<Songs> songsplaylist = [];
  List<PlaylistSongs> playlistname1 = box1.values.toList();

  bool isdup =
      playlistname1.where((element) => element.platlistname == name).isEmpty;
  if (isdup) {
    box1.add(PlaylistSongs(platlistname: name, playlistsongs: songsplaylist));
  } else {
    const snackBar = SnackBar(
      duration: Duration(seconds: 1),
      content: Padding(
        padding: EdgeInsets.all(18.0),
        child: Text(
          'Playlist already exist',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      dismissDirection: DismissDirection.down,
      elevation: 10,
      padding: EdgeInsets.only(top: 10, bottom: 15),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
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
