import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer/db_funtion/favorate_db_model.dart';
import 'package:musicplayer/db_funtion/mostlyplayed.dart';
import 'package:musicplayer/db_funtion/recentlyplayed.dart';

late Box<Favourites> favouritesdb;
openFavouritesDB() async {
  favouritesdb = await Hive.openBox<Favourites>('Favourites');
}

late Box<RecentlyPlayed> recentlyPlayedBox;
openRecentlyPlayeddb() async {
  recentlyPlayedBox = await Hive.openBox('recentlyplayed');
}

late Box<MostPlayed> mostPlayedSongs;
openMostPlayeddb() async {
  mostPlayedSongs = await Hive.openBox("Mostplayed");
}

recentlyPlayedFunction(RecentlyPlayed value) {
  List<RecentlyPlayed> recentSongs = recentlyPlayedBox.values.toList();

  bool isThere = recentSongs
      .where((element) => element.songname == value.songname)
      .isEmpty;
  if (isThere == true) {
    recentlyPlayedBox.add(value);
  } else {
    int index =
        recentSongs.indexWhere((element) => element.songname == value.songname);
    recentlyPlayedBox.deleteAt(index);
    recentlyPlayedBox.add(value);
  }
}

updateSongPlayedCount(MostPlayed value, int index) {
  // final box = MostPlayedBox.getInstance();
  List<MostPlayed> mostlist = mostPlayedSongs.values.toList();

  bool isThere =
      mostlist.where((element) => element.songname == value.songname).isEmpty;
  if (isThere == true) {
    mostPlayedSongs.add(value);
  } else {
    int index =
        mostlist.indexWhere((element) => element.songname == value.songname);
    mostPlayedSongs.deleteAt(index);
    mostPlayedSongs.put(index, value);
  }
  int count = value.count;
  value.count = count + 1;
}
