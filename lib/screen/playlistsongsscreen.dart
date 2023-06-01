import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:musicplayer/application/playlist_provider.dart';
import 'package:musicplayer/db_funtion/playlistmodel.dart';
import 'package:musicplayer/db_funtion/songdb_model.dart';
import 'package:musicplayer/screen/nowplaying_slider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

// ignore: must_be_immutable
class PlayListSongsList extends StatelessWidget {
  PlayListSongsList({
    super.key,
    required int this.playindex,
    required this.playlistname,
  });
  int? playindex;
  String? playlistname;
  final AssetsAudioPlayer audioplayerPlaylist = AssetsAudioPlayer.withId('0');

  List<Audio> convertAudios = [];

  

  @override
  Widget build(BuildContext context) {
    // log(Provider.of<PlayListProvider>(context).playSong[widget.playindex!].songname!);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PlayListProvider>(context, listen: false)
          .playlistconvert(playindex);
      Provider.of<PlayListProvider>(context, listen: false)
          .displaySongs(playindex);
    });
    final playbox = PlaylistSongsbox.getInstance();
    // List<PlaylistSongs> playlistsong = playbox.values.toList();
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        // ignore: prefer_const_constructors
        title: Text(
          playlistname.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
          height: double.infinity,
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
              padding: const EdgeInsets.only(top: 28.0),
              child: Consumer<PlayListProvider>(
                builder: (context, value, child) {
                  final playListSongs = value.playSong;
                  if (playListSongs.isEmpty) {
                    return Center(
                      child: Container(
                          child: Lottie.network(
                              'https://assets6.lottiefiles.com/private_files/lf30_cgfdhxgx.json',
                              height: 400,
                              width: 500,
                              fit: BoxFit.cover)),
                    );
                  }

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: playListSongs.length,
                    itemBuilder: ((context, index) {
                      log("vrgtv");

                      return ListTile(
                        leading: playListSongs[index].songname!.isNotEmpty
                            ? QueryArtworkWidget(
                                keepOldArtwork: true,
                                artworkBorder: BorderRadius.circular(10),
                                id: value.playSong[index].id!,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/logo_music_player-removebg-preview.png',
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: Image.asset(
                                  'assets/logo_music_player-removebg-preview.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                        title: TextScroll(
                          mode: TextScrollMode.endless,
                          velocity:
                              const Velocity(pixelsPerSecond: Offset(80, 0)),
                          delayBefore: const Duration(milliseconds: 500),
                          numberOfReps: 5,
                          pauseBetween: const Duration(milliseconds: 50),
                          playListSongs[index].songname!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(playListSongs[index].artist!,
                            style: const TextStyle(color: Colors.white)),
                        trailing: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                // playListSongs.removeAt(index);
                                playListSongs.removeAt(index);
                                playbox.putAt(
                                    playindex!,
                                    PlaylistSongs(
                                        platlistname: playlistname!,
                                        playlistsongs: playListSongs));
                                final snackBar = SnackBar(
                                  duration: const Duration(seconds: 1),
                                  content: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.playlist_remove,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'Removed from  $playlistname',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  backgroundColor: Colors.black,
                                  dismissDirection: DismissDirection.down,
                                  elevation: 10,
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 15),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);

                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            PlayListSongsList(
                                                playindex: playindex!,
                                                playlistname: playlistname),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                                Provider.of<PlayListProvider>(context,
                                        listen: false)
                                    .playlistconvert(index);
                                Provider.of<PlayListProvider>(context,
                                        listen: false)
                                    .displaySongs(index);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          audioplayerPlaylist.open(
                            Playlist(
                                audios: value.convertAudios, startIndex: index),
                            headPhoneStrategy:
                                HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
                            showNotification: true,
                          );
                        },
                      );
                    }),
                  );
                },
              ))
          
          ),
      bottomSheet: NowPlayingSlider(),
    );
  }
}
