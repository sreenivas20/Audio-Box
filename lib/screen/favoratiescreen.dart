import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer/db_funtion/favorate_db_model.dart';
import 'package:musicplayer/screen/functions/addtofavourites.dart';
import 'package:musicplayer/screen/homescreen.dart';
import 'package:musicplayer/screen/playingscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';



class FavoriteScreen extends StatefulWidget {
  FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

final _audioPlayer = AssetsAudioPlayer.withId('0');

class _FavoriteScreenState extends State<FavoriteScreen> {
  final List<Favourites> favourite = [];
  final box = FavSongBox.getInstance();
  late List<Favourites> favouritesongs = box.values.toList();
  bool isalready = true;
  List<Audio> favSongs = [];

  int currentIndex = 0;

  @override
  void initState() {
    final List<Favourites> favouritesongs1 =
        box.values.toList().reversed.toList();
    for (var element in favouritesongs1) {
      favSongs.add(
        Audio.file(
          element.songUrl.toString(),
          metas: Metas(
            artist: element.artist,
            title: element.songname,
            id: element.id.toString(),
          ),
        ),
      );
    }
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Liked Songs',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.blueGrey.shade300,
              Colors.black,
              Colors.black,
              Colors.black
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 120, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Liked Songs',
                  style: TextStyle(color: Colors.white, fontSize: 26),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20, right: 10, bottom: 28),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.play_circle_filled,
                        color: Colors.white,
                        size: 60,
                      )),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: ValueListenableBuilder<Box<Favourites>>(
                valueListenable: box.listenable(),
                builder: (context, favouriteDb, child) {
                  List<Favourites> favouritesongs =
                      favouriteDb.values.toList().reversed.toList();
                  return favouritesongs.isNotEmpty
                      ? (ListView.builder(
                          padding: const EdgeInsets.only(top: 12),
                          shrinkWrap: true,
                          itemCount: favouritesongs.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: ((context, index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: customList(
                                    favouritesongs[index].songname!,
                                    QueryArtworkWidget(
                                      id: favouritesongs[index].id!,
                                      type: ArtworkType.AUDIO,
                                      nullArtworkWidget: ClipRRect(
                                        child: Image.asset(
                                            'assets/logo_music_player-removebg-preview.png'),
                                      ),
                                    ),
                                    favouritesongs[index].artist ??
                                        " No Artist",
                                    index),
                              )),
                        ))
                      : const Center(
                          child: Text(
                            "You haven't Liked any songs!",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                }),
          )
        ],
      ),
    );
  }

  Widget customList(String? musicName, imagecover, String sub, index) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
        width: 290,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 25, 35, 40),
              Color.fromARGB(255, 24, 33, 38),
              Colors.transparent,
            ],
          ),
        ),
        child: Center(
          child: ListTile(
            onTap: () {
              PlayingScreen.playingNowIndex.value = index;

              _audioPlayer.open(Playlist(audios: favSongs, startIndex: index),
                  showNotification: true,
                  headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
                  loopMode: LoopMode.playlist);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => PlayingScreen()));
              // setState(() {});
            },
            leading: imagecover,
            title: Text(
              musicName!,
              style: const TextStyle(
                  color: Colors.white, overflow: TextOverflow.ellipsis),
            ),
            subtitle: Text(
              sub,
              style: const TextStyle(
                color: Colors.white,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        deleteFavSongs(index, context);

                       
                      });
                      final snackBar = SnackBar(
                        duration: const Duration(seconds: 1),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.favorite,
                                color: Colors.white,
                              ),
                              Text(
                                'Removed from Favouraites',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        backgroundColor: Colors.black,
                        dismissDirection: DismissDirection.down,
                        elevation: 10,
                        padding: const EdgeInsets.only(top: 10, bottom: 15),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // onPlay() {
  //   final List<Favourites> favouritesongs1 =
  //       box.values.toList().reversed.toList();
  //   for (var element in favouritesongs1) {
  //     favSongs.add(
  //       Audio.file(
  //         element.songUrl.toString(),
  //         metas: Metas(
  //           artist: element.artist,
  //           title: element.songname,
  //           id: element.id.toString(),
  //         ),
  //       ),
  //     );
  //   }
  // }
}
