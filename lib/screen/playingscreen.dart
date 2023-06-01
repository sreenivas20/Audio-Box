import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer/application/favorate_provider.dart';

import 'package:musicplayer/db_funtion/songdb_model.dart';
import 'package:musicplayer/screen/functions/addtofavourites.dart';
import 'package:musicplayer/screen/homescreen.dart';
import 'package:musicplayer/screen/liyric.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

// ignore: must_be_immutable
class PlayingScreen extends StatefulWidget {
  PlayingScreen({super.key});

  List<Songs>? songs;
  static int? indexValue = 0;
  static ValueNotifier<int> playingNowIndex = ValueNotifier<int>(indexValue!);
  @override
  State<PlayingScreen> createState() => _PlayingScreenState();
}

final _audioplayer = AssetsAudioPlayer.withId('0');
final box = SongBox.getInstance();

class _PlayingScreenState extends State<PlayingScreen> {
  int currentIndex = 0;
  bool isRepeat = false;

  bool isShuffleOn = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
  }

  void _onFavoriteButtonPress() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  var size, height, width;

  @override
  Widget build(BuildContext context) {
  final dbPro = Provider.of<FavoriteProvider>(context);

    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    Duration duration = Duration.zero;
    Duration position = Duration.zero;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        backgroundColor: Colors.transparent,
        title: const Text(
          'Playing...',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                getLyrics(context);
              },
              icon: const Icon(
                Icons.library_music_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.blueGrey.shade300,
                  Colors.black,
                  Colors.black,
                  Colors.black
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: ValueListenableBuilder(
                valueListenable: PlayingScreen.playingNowIndex,
                builder: (BuildContext context, int playing, child) {
                  return ValueListenableBuilder<Box<Songs>>(
                    valueListenable: box.listenable(),
                    builder: ((context, Box<Songs> allsongBox, child) {
                      List<Songs> allsongs = allsongBox.values.toList();
                      if (allsongs.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      // ignore: unnecessary_null_comparison
                      if (allsongs == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return audioPlayer2.builderCurrent(
                        builder: ((context, playing) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              QueryArtworkWidget(
                                artworkHeight: height * 0.29,
                                artworkWidth: width * 0.79,
                                artworkBorder: BorderRadius.circular(10),
                                artworkFit: BoxFit.cover,
                                id: int.parse(playing.audio.audio.metas.id!),
                                type: ArtworkType.AUDIO,
                                keepOldArtwork: true,
                                nullArtworkWidget: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/logo_music_player-removebg-preview.png',
                                    width: 230,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 12.0, left: 12),
                                    child: TextScroll(
                                      mode: TextScrollMode.endless,
                                      velocity: const Velocity(
                                          pixelsPerSecond: Offset(80, 0)),
                                      delayBefore:
                                          const Duration(milliseconds: 500),
                                      numberOfReps: 5,
                                      pauseBetween:
                                          const Duration(milliseconds: 50),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                      textAlign: TextAlign.right,
                                      selectable: false,
                                      audioPlayer2.getCurrentAudioTitle,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextScroll(
                                      audioPlayer2.getCurrentAudioArtist,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 38.0, top: 50),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (dbPro.checkFavoritesStatus(
                                                int.parse(playing
                                                    .audio.audio.metas.id!),
                                                BuildContext)) {
                                              dbPro.addToFavourite(int.parse(playing
                                                  .audio.audio.metas.id!));
                                            } else if (!dbPro.checkFavoritesStatus(
                                                int.parse(playing
                                                    .audio.audio.metas.id!),
                                                BuildContext)) {
                                              dbPro.removeFavSong(int.parse(playing
                                                  .audio.audio.metas.id!));
                                            }
                                            setState(() {
                                              dbPro.checkFavoritesStatus(
                                                      int.parse(playing.audio
                                                          .audio.metas.id!),
                                                      BuildContext) ==
                                                  !dbPro.checkFavoritesStatus(
                                                      int.parse(playing.audio
                                                          .audio.metas.id!),
                                                      BuildContext);
                                            });
                                          },
                                          icon: dbPro.checkFavoritesStatus(
                                                  int.parse(playing
                                                      .audio.audio.metas.id!),
                                                  BuildContext)
                                              ? const Icon(
                                                  Icons.favorite_outline,
                                                  color: Colors.white,
                                                )
                                              : const Icon(
                                                  Icons.favorite,
                                                  color: Colors.white,
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: [
                                  PlayerBuilder.realtimePlayingInfos(
                                    player: audioPlayer2,
                                    builder: (context, RealtimePlayingInfos) {
                                      duration = RealtimePlayingInfos
                                          .current!.audio.duration;
                                      position =
                                          RealtimePlayingInfos.currentPosition;

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50, right: 50),
                                        child: ProgressBar(
                                          barHeight: 6,
                                          baseBarColor:
                                              Colors.white.withOpacity(0.5),
                                          progressBarColor: Colors.white,
                                          thumbColor: Colors.white,
                                          thumbRadius: 9,
                                          timeLabelPadding: 7,
                                          progress: position,
                                          timeLabelTextStyle: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          total: duration,
                                          onSeek: (duration) async {
                                            await audioPlayer2.seek(duration);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  PlayerBuilder.isPlaying(
                                    player: audioPlayer2,
                                    builder: ((context, isPlaying) {
                                      return Container(
                                        width: height * 0.418,
                                        height: width * 0.330,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.black),
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    audioPlayer2
                                                        .toggleShuffle();
                                                  });
                                                },
                                                icon: (isShuffleOn)
                                                    ? const Icon(
                                                        Icons.shuffle_on,
                                                        color: Colors.white,
                                                      )
                                                    : const Icon(
                                                        Icons.shuffle_outlined,
                                                        color: Colors.white)),
                                            // SizedBox(
                                            //   width: width * 0.10,
                                            // ),
                                            IconButton(
                                                onPressed: () async {
                                                  await audioPlayer2.previous();
                                                },
                                                icon: const Icon(
                                                  Icons.skip_previous_outlined,
                                                  color: Colors.white,
                                                  size: 38,
                                                )),
                                            // const SizedBox(
                                            //   width: 8,
                                            // ),
                                            IconButton(
                                                onPressed: () async {
                                                  if (isPlaying) {
                                                    await audioPlayer2.pause();
                                                  } else {
                                                    await audioPlayer2.play();
                                                  }
                                                  setState(() {
                                                    isPlaying = !isPlaying;
                                                  });
                                                },
                                                icon: Icon(
                                                  isPlaying
                                                      ? Icons
                                                          .pause_circle_filled
                                                      : Icons
                                                          .play_circle_filled,
                                                  color: Colors.white,
                                                  size: 58,
                                                )),
                                            const SizedBox(
                                              width: 0,
                                              height: 30,
                                            ),
                                            IconButton(
                                                onPressed: () async {
                                                  await audioPlayer2.next();
                                                },
                                                icon: const Icon(
                                                  Icons.skip_next_outlined,
                                                  color: Colors.white,
                                                  size: 38,
                                                )),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  setState(
                                                    () {
                                                      if (isRepeat) {
                                                        audioPlayer2
                                                            .setLoopMode(
                                                                LoopMode.none);
                                                        isRepeat = false;
                                                      } else {
                                                        audioPlayer2
                                                            .setLoopMode(
                                                                LoopMode
                                                                    .single);
                                                        isRepeat = true;
                                                      }
                                                    },
                                                  );
                                                },
                                                icon: (isRepeat)
                                                    ? const Icon(
                                                        Icons
                                                            .repeat_one_on_outlined,
                                                        color: Colors.white,
                                                      )
                                                    : const Icon(
                                                        Icons.repeat,
                                                        color: Colors.white,
                                                      )),
                                          ],
                                        ),
                                      );
                                    }),
                                  )
                                ],
                              )
                            ],
                          );
                        }),
                      );
                    }),
                  );
                }),
          ),
        ],
      ),
    );
  }

  // void changeToSeconds(int seconds) {
  //   Duration duration = Duration(seconds: seconds);
  //   widget.audioPlayer.seek(duration);
  // }
}
