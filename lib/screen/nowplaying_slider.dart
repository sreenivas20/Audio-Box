import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:musicplayer/db_funtion/songdb_model.dart';
// import 'package:musicplayer/screen/homescreen.dart';
import 'package:musicplayer/screen/playingscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:text_scroll/text_scroll.dart';

class NowPlayingSlider extends StatefulWidget {
  NowPlayingSlider({super.key});

  static int? index = 0;
  static ValueNotifier<int> enteredvalue = ValueNotifier<int>(index!);
  List<Songs> dbsongs = box.values.toList();
  @override
  State<NowPlayingSlider> createState() => _NowPlayingSliderState();
}

class _NowPlayingSliderState extends State<NowPlayingSlider> {
  final AssetsAudioPlayer audioPlayerSlider = AssetsAudioPlayer.withId('0');
  @override
  Widget build(BuildContext context) {
    double vwidth = MediaQuery.of(context).size.width;
    double vheight = MediaQuery.of(context).size.height;
    return audioPlayerSlider.builderCurrent(builder: (context, playing) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              fullscreenDialog: true,
              builder: (context) => PlayingScreen(),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          width: vwidth,
          height: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: QueryArtworkWidget(
                  quality: 100,
                  artworkWidth: vwidth * 0.16,
                  artworkHeight: vheight * 0.16,
                  keepOldArtwork: true,
                  artworkBorder: BorderRadius.circular(10),
                  id: int.parse(playing.audio.audio.metas.id!),
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/logo_music_player-removebg-preview.png',
                      width: vwidth * 0.1,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: vwidth * 0.4,
                    child: TextScroll(
                      audioPlayerSlider.getCurrentAudioTitle,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: vwidth * 0.4,
                    child: TextScroll(
                      // allDbdongs[value].artist ?? "No Artist",
                      audioPlayerSlider.getCurrentAudioArtist,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              PlayerBuilder.isPlaying(
                player: audioPlayerSlider,
                builder: ((context, isPlaying) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: vwidth * 0.012,
                    ),
                    child: Wrap(
                      spacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.black,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              await audioPlayerSlider.previous();
                            },
                            icon: const Icon(
                              Icons.skip_previous,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.black),
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  (isPlaying)
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_filled,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  await audioPlayerSlider.playOrPause();

                                  // playsong(value);
                                  setState(() {
                                    isPlaying = !isPlaying;
                                  });
                                },
                              ),
                            )),
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.black),
                          child: IconButton(
                            onPressed: () async {
                              await audioPlayerSlider.next();
                            },
                            icon: const Icon(
                              Icons.skip_next,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      );
    });
  }
}
