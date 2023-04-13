import 'package:flutter/material.dart';
import 'package:musicplayer/db_funtion/all_db_functions.dart';
import 'package:musicplayer/db_funtion/favorate_db_model.dart';
import 'package:musicplayer/db_funtion/songdb_model.dart';
import 'package:musicplayer/screen/favoratiescreen.dart';
import 'package:musicplayer/screen/playingscreen.dart';
// import 'package:musicplayer/screen/homescreen.dart';

addToFavourite(int index) async {
  List<Songs> dbsongs = box.values.toList();

  List<Favourites> favouritessongs = [];
  favouritessongs = favouritesdb.values.toList();
  bool isalready = favouritessongs
      .where((element) => element.songname == dbsongs[index].songname)
      .isEmpty;

  if (isalready) {
    favouritesdb.add(Favourites(
        songname: dbsongs[index].songname,
        artist: dbsongs[index].artist,
        duration: dbsongs[index].duration,
        songUrl: dbsongs[index].songUrl,
        id: dbsongs[index].id));
  } else {
    favouritessongs
        .where((element) => element.songname == dbsongs[index].songname);
    int currentindex = favouritessongs
        .indexWhere((element) => element.id == dbsongs[index].id);
    await favouritesdb.deleteAt(currentindex);
    // await favouritesdb.deleteAt(index);
  }
}

bool checkFavoritesStatus(int index, BuildContext) {
  List<Favourites> favouritesongs = [];
  List<Songs> dbsongs = box.values.toList();
  Favourites value = Favourites(
      songname: dbsongs[index].songname,
      artist: dbsongs[index].artist,
      duration: dbsongs[index].duration,
      songUrl: dbsongs[index].songUrl,
      id: dbsongs[index].id);

  favouritesongs = favouritesdb.values.toList();
  bool isAlreadyThere = favouritesongs
      .where((element) => element.songname == value.songname)
      .isEmpty;
  return isAlreadyThere ? true : false;
}

removeFavSong(int index) async {
  final box4 = FavSongBox.getInstance();
  List<Favourites> favsongs = box4.values.toList();
  List<Songs> dbsongs = box.values.toList();
  int currentIndex =
      favsongs.indexWhere((element) => element.id == dbsongs[index].id);
  await favouritesdb.deleteAt(currentIndex);
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
