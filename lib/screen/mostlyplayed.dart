import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer/application/mostlyplated_provider.dart';
import 'package:musicplayer/db_funtion/mostlyplayed.dart';
import 'package:musicplayer/screen/nowplaying_slider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class MostlyPlayedScreen extends StatelessWidget {
   MostlyPlayedScreen({super.key});

  // final box = MostPlayedBox.getInstance();
  final AssetsAudioPlayer _audioPlayerMost = AssetsAudioPlayer.withId('0');

  Widget customList(cover, musicName, sub, mostIndex,context) {
    final mostPro = Provider.of<MostlyPlayedProvider>(context);
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
                Playlist(audios: mostPro.songs, startIndex: mostIndex),
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
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MostlyPlayedProvider>(context, listen: false).mostlyPlayer();
    });
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
            child: Consumer<MostlyPlayedProvider>(
              builder: (context, value, child) {
                final mostPlayedPro = value.mostfinalsong;

                return mostPlayedPro.isNotEmpty
                    ? ListView.builder(
                        itemCount: mostPlayedPro.length,
                        itemBuilder: ((context, mostIndex) => customList(
                            QueryArtworkWidget(
                              id: mostPlayedPro[mostIndex].id,
                              keepOldArtwork: true,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/logo_music_player-removebg-preview.png',
                                ),
                              ),
                            ),
                            mostPlayedPro[mostIndex].songname,
                            mostPlayedPro[mostIndex].artist,
                            mostIndex,context)),
                      )
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
            )),
      ),
      bottomSheet: NowPlayingSlider(),
    );
  }
}
