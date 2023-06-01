import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:musicplayer/application/favorate_provider.dart';
import 'package:musicplayer/application/favoritepage_provider.dart';

import 'package:musicplayer/screen/nowplaying_slider.dart';
// import 'package:musicplayer/screen/homescreen.dart';
import 'package:musicplayer/screen/playingscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({super.key});

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<FavoritePageProvider>(context, listen: false)
          .initStateProviderFav();
    });

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
              child: Consumer<FavoritePageProvider>(
                  builder: ((context, value, child) {
                // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                // });

                final favDb = value.favouritesongs1;
                if (favDb.isEmpty) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(right: 8.0, top: 30, left: 0),
                    child: SizedBox(
                        child: Image.asset(
                      'assets/animation_500_licqwy2q.gif',
                      width: 500,
                      height: 500,
                      fit: BoxFit.cover,
                    )),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 12),
                  shrinkWrap: true,
                  itemCount: favDb.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: ((context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: customList(
                            favDb[index].songname!,
                            QueryArtworkWidget(
                              id: favDb[index].id!,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: ClipRRect(
                                child: Image.asset(
                                    'assets/logo_music_player-removebg-preview.png'),
                              ),
                            ),
                            favDb[index].artist ?? " No Artist",
                            index,
                            context),
                      )),
                );
              })))
        ],
      ),
      bottomSheet: NowPlayingSlider(),
    );
  }

  Widget customList(String? musicName, imagecover, String sub, index, context) {
    final dbPro = Provider.of<FavoriteProvider>(context);
    final favdb = Provider.of<FavoritePageProvider>(context);

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

              _audioPlayer.open(
                Playlist(audios: favdb.favSongs, startIndex: index),
                showNotification: true,
                headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
              );

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
                      dbPro.deleteFavSongs(index, context);

                      const snackBar = SnackBar(
                        duration: Duration(seconds: 1),
                        content: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
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
                        padding: EdgeInsets.only(top: 10, bottom: 15),
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
}

final _audioPlayer = AssetsAudioPlayer.withId('0');
