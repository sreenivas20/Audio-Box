import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer/db_funtion/playlistmodel.dart';
import 'package:musicplayer/db_funtion/songdb_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:text_scroll/text_scroll.dart';

// ignore: must_be_immutable
class PlayListSongsList extends StatefulWidget {
  PlayListSongsList({
    super.key,
    required int this.playindex,
    required this.playlistname,
  });
  int? playindex;
  String? playlistname;
  @override
  State<PlayListSongsList> createState() => _PlayListSongsListState();
}

class _PlayListSongsListState extends State<PlayListSongsList> {
  final AssetsAudioPlayer audioplayerPlaylist = AssetsAudioPlayer.withId('0');
  List<Audio> convertAudios = [];
  @override
  void initState() {
    // TODO: implement initState
    final playbox = PlaylistSongsbox.getInstance();
    List<PlaylistSongs> playlistsongs = playbox.values.toList();
    for (var item in playlistsongs[widget.playindex!].playlistsongs!) {
      convertAudios.add(
        Audio.file(
          item.songUrl!,
          metas: Metas(
            title: item.songname,
            artist: item.artist,
            id: item.id.toString(),
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final playbox = PlaylistSongsbox.getInstance();
    List<PlaylistSongs> playlistsong = playbox.values.toList();
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
          'Playlist Songs',
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
          child: ValueListenableBuilder<Box<PlaylistSongs>>(
            valueListenable: playbox.listenable(),
            builder: (context, Box<PlaylistSongs> playlistsongs, child) {
              List<PlaylistSongs> playlistsong = playlistsongs.values.toList();
              List<Songs>? playsong =
                  playlistsong[widget.playindex!].playlistsongs;

              return playsong!.isNotEmpty
                  ? (ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: playsong.length,
                      itemBuilder: ((context, index) => ListTile(
                            leading: playlistsong[widget.playindex!]
                                    .playlistsongs!
                                    .isNotEmpty
                                ? QueryArtworkWidget(
                                    keepOldArtwork: true,
                                    artworkBorder: BorderRadius.circular(10),
                                    id: playlistsong[widget.playindex!]
                                        .playlistsongs![index]
                                        .id!,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/logo_music_player-removebg-preview.png',
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: Image.asset(
                                      'assets/logo_music_player-removebg-preview.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            title: TextScroll(
                              mode: TextScrollMode.endless,
                              velocity: const Velocity(
                                  pixelsPerSecond: Offset(80, 0)),
                              delayBefore: const Duration(milliseconds: 500),
                              numberOfReps: 5,
                              pauseBetween: const Duration(milliseconds: 50),
                              playsong[index].songname!,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(playsong[index].artist!,
                                style: const TextStyle(color: Colors.white)),
                            trailing: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(
                                      () {
                                        playsong.removeAt(index);
                                        playlistsong
                                            .removeAt(widget.playindex!);
                                        playbox.putAt(
                                            widget.playindex!,
                                            PlaylistSongs(
                                                platlistname:
                                                    widget.playlistname!,
                                                playlistsongs: playsong));
                                        final snackBar = SnackBar(
                                          content: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.playlist_remove,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  'Removed from  ${widget.playlistname}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          backgroundColor: Colors.black,
                                          dismissDirection:
                                              DismissDirection.down,
                                          elevation: 10,
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 15),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      },
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation1,
                                                animation2) =>
                                            PlayListSongsList(
                                                playindex: widget.playindex!,
                                                playlistname:
                                                    widget.playlistname),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
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
                                    audios: convertAudios, startIndex: index),
                                headPhoneStrategy:
                                    HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
                                showNotification: true,
                              );
                            },
                          )),
                    ))
                  // ignore: prefer_const_constructors
                  : Padding(
                      padding: const EdgeInsets.only(top: 0.3),
                      child: const Center(
                        child: Text("Please add a song!",
                            style: TextStyle(color: Colors.white)),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
