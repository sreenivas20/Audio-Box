import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/db_funtion/recentlyplayed.dart';

class RecentlyPlayedProvider extends ChangeNotifier {
  final List<RecentlyPlayed> recentplay = [];
  final box = RecentlyPlayedBox.getInstance();
  List<Audio> _rcentplay = [];
  List<Audio> get rcentplay => _rcentplay;

  List<RecentlyPlayed> _recentlyplayed = [];
  List<RecentlyPlayed> get recentlyplayed => _recentlyplayed;

  void recentlyPlayer() {
    final box = RecentlyPlayedBox.getInstance();
    _recentlyplayed = box.values.toList().reversed.toList();
    for (var item in _recentlyplayed) {
      _rcentplay.add(
        Audio.file(
          item.songurl.toString(),
          metas: Metas(
            artist: item.artist,
            title: item.songname,
            id: item.id.toString(),
          ),
        ),
      );
    }
    notifyListeners();
  }
}
