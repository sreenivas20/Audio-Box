import 'package:flutter/material.dart';
import 'package:musicplayer/db_funtion/all_db_functions.dart';
import 'package:musicplayer/db_funtion/favorate_db_model.dart';
import 'package:musicplayer/db_funtion/songdb_model.dart';
import 'package:musicplayer/screen/favoratiescreen.dart';
import 'package:musicplayer/screen/playingscreen.dart';
// import 'package:musicplayer/screen/homescreen.dart';

addToFavourite(int? id) async {
  List<Songs> dbsongs = box.values.toList();

  List<Favourites> favouritessongs = [];
  favouritessongs = favouritesdb.values.toList();
  bool isalready = favouritessongs.any((element) => element.id == id);

  if (!isalready) {
    Songs song = dbsongs.firstWhere((element) => element.id == id);

    favouritesdb.add(Favourites(
        songname: song.songname,
        artist: song.artist,
        duration: song.duration,
        songUrl: song.songUrl,
        id: song.id));
  } else {
    // favouritessongs
    //     .where((element) => element.songname == dbsongs[id].songname);
    int currentindex =
        favouritessongs.indexWhere((element) => element.id == id);
    await favouritesdb.deleteAt(currentindex);
    // await favouritesdb.deleteAt(index);
  }
}

bool checkFavoritesStatus(int? songId, BuildContext) {
  List<Favourites> favouritesongs = [];
  List<Songs> dbsongs = box.values.toList();
  Songs song = dbsongs.firstWhere((element) => element.id == songId);

  Favourites value = Favourites(
      songname: song.songname,
      artist: song.artist,
      duration: song.duration,
      songUrl: song.songUrl,
      id: song.id);

  favouritesongs = favouritesdb.values.toList();
  bool isAlreadyThere =
      favouritesongs.where((element) => element.id == value.id).isEmpty;
  return isAlreadyThere;
}

removeFavSong(int? songId) async {
  final box4 = FavSongBox.getInstance();
  List<Favourites> favsongs = box4.values.toList();
  List<Songs> dbsongs = box.values.toList();
  int currentIndex = favsongs.indexWhere((element) => element.id == songId);
  if (currentIndex >= 0) {
    await favouritesdb.deleteAt(currentIndex);
  }
}

deleteFavSongs(int index, BuildContext context) async {
  await favouritesdb.deleteAt(favouritesdb.length - index - 1);
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => FavoriteScreen(),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
}
