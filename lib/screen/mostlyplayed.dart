import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer/db_funtion/mostlyplayed.dart';
import 'package:musicplayer/screen/nowplaying_slider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:text_scroll/text_scroll.dart';

class MostlyPlayedScreen extends StatefulWidget {
  const MostlyPlayedScreen({super.key});

  @override
  State<MostlyPlayedScreen> createState() => _MostlyPlayedScreenState();
}

class _MostlyPlayedScreenState extends State<MostlyPlayedScreen> {
  final box = MostPlayedBox.getInstance();
  final AssetsAudioPlayer _audioPlayerMost = AssetsAudioPlayer.withId('0');
  List<Audio> songs = [];

  @override
  void initState() {
    List<MostPlayed> songlist = box.values.toList();

    int i = 0;
    for (var item in songlist) {
      if (item.count > 3) {
        mostfinalsong.insert(i, item);
        i++;
      }
    }

    for (var item in mostfinalsong) {
      songs.add(Audio.file(item.songurl,
          metas: Metas(
              title: item.songname,
              artist: item.artist,
              id: item.id.toString())));
    }

    super.initState();
  }

  List<MostPlayed> mostfinalsong = [];

  Widget customList(cover, musicName, sub, mostIndex) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 10, right: 10),
      child: Container(
        width: 320,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 25, 35, 40),
              Color.fromARGB(255, 24, 33, 38),
              // Colors.orange
            ],
            // begin: Alignment.bottomRight,
            // end: Alignment.topRight,
          ),
        ),
        child: Center(
          child: ListTile(
            onTap: () {
              _audioPlayerMost.open(
                Playlist(audios: songs, startIndex: mostIndex),
                headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
                showNotification: true,
              );
            },
            leading: cover,
            title: TextScroll(
              musicName,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle:
                TextScroll(sub, style: const TextStyle(color: Colors.white)),

            // trailing: Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     IconButton(
            //         onPressed: _onFavoriteButtonPress,
            //         icon: Icon(
            //           _isFavorite
            //               ? Icons.favorite
            //               : Icons.favorite_border_outlined,
            //           color: Colors.white,
            //           // size: ,
            //         )),
            //     PopupMenuButton(
            //       color: Colors.white,
            //       itemBuilder: (context) {
            //         return [
            //           const PopupMenuItem(
            //             value: 1,
            //             child: Text('Remove songs'),
            //           ),
            //         ];
            //       },
            //       onSelected: (value) {
            //         if (value == 1) {
            //           removeBox();
            //         }
            //       },
            //     ),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Mostly played',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueGrey.shade300,
              Colors.black,
              Colors.black,
              Colors.black
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0, right: 8, left: 8),
          child: ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, Box<MostPlayed> mostplayedDB, child) {
              List<MostPlayed> mostplayedsong = mostplayedDB.values.toList();

              return mostfinalsong.isNotEmpty
                  ? ListView.builder(
                      itemCount: mostfinalsong.length,
                      itemBuilder: ((context, mostIndex) => customList(
                          QueryArtworkWidget(
                            id: mostfinalsong[mostIndex].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/logo_music_player-removebg-preview.png',
                              ),
                            ),
                          ),
                          mostfinalsong[mostIndex].songname,
                          mostfinalsong[mostIndex].artist,
                          mostIndex)))
                  : const Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Center(
                        child: Text(
                          "Your most played songs will appear here!",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
      bottomSheet: NowPlayingSlider(),
    );
  }

  // void removeBox() {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog( shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       title: const Text("Remove song "),
  //       content: const Text('Are you sure'),
  //       actions: <Widget>[
  //         Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(ctx).pop();
  //               },
  //               child: const Text(
  //                 "Cancel",
  //                 style: TextStyle(color: Colors.blue),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(ctx).pop();
  //               },
  //               child: const Text(
  //                 "Remove",
  //                 style: TextStyle(color: Colors.red),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
