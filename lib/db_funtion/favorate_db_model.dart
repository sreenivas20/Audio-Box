import 'package:hive_flutter/hive_flutter.dart';
part 'favorate_db_model.g.dart';

@HiveType(typeId: 1)
class Favourites {
  @HiveField(0)
  String? songname;

  @HiveField(1)
  String? artist;

  @HiveField(2)
  int? duration;

  @HiveField(3)
  String? songUrl;

  @HiveField(4)
  int? id;

  Favourites(
      {required this.songname,
      required this.artist,
      required this.duration,
      required this.songUrl,
      required this.id});
}

String boxName1 = 'Favourites';

class FavSongBox {
  static Box<Favourites>? _box;
  static Box<Favourites> getInstance() {
    return _box ??= Hive.box(boxName1);
  }
}
