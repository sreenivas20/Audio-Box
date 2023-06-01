import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/application/search_provider.dart';
import 'package:musicplayer/db_funtion/songdb_model.dart';
import 'package:musicplayer/screen/nowplaying_slider.dart';
// import 'package:musicplayer/screen/homescreen.dart';
import 'package:musicplayer/screen/playingscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final AssetsAudioPlayer _audioPlayersearch = AssetsAudioPlayer.withId('0');

  final box = SongBox.getInstance();

  final TextEditingController _searchController = TextEditingController();

  final songbox = SongBox.getInstance();

  Widget searchTextField(context) {
    // final dbPro = Provider.of<SearchProvider>(context);

    return TextFormField(
      onTapOutside: (event) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onChanged: (value) {
        Provider.of<SearchProvider>(context, listen: false).searchList(value);
        log(value);
      },
      autofocus: true,
      controller: _searchController,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          color: Colors.blueGrey.shade300,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.blueGrey.shade300,
          ),
          onPressed: () => clearText(),
        ),
        filled: true,
        fillColor: Colors.black,
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(60)),
        hintText: 'search',
        hintStyle: const TextStyle(color: Colors.white),
      ),
    );
  }

  void clearText() {
    _searchController.clear();
  }

  Widget customList(cover, musicName, sub, index, context) {
    final dbPro = Provider.of<SearchProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 25, right: 20),
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
            onTap: () async {
              PlayingScreen.playingNowIndex.value = index;
              await _audioPlayersearch.open(
                  Playlist(audios: dbPro.allSongs, startIndex: index),
                  headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
                  showNotification: true,
                  loopMode: LoopMode.playlist);
              // Navigator.of(context).push(CupertinoPageRoute(
              //     fullscreenDialog: true, builder: ((ctx) => PlayingScreen())));
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
    // final dbPro = Provider.of<SearchProvider>(context);
    log('builder');
    Provider.of<SearchProvider>(context).initStateFuntion();
    return Scaffold(
      bottomSheet: NowPlayingSlider(),
      backgroundColor: Colors.transparent,
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
            padding: const EdgeInsets.only(top: 60.0, left: 20, right: 20),
            child: searchTextField(context),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 140.0),
            child: Consumer<SearchProvider>(builder: (context, value, child) {
              // final dbPro = Provider.of<SearchProvider>(context);

              if (value.anotherList.isEmpty) {
                return Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 200.0, left: 8, right: 15),
                    child: Container(
                        child: Image.asset('assets/animation_500_licqkway.gif',
                            height: 400, width: 500, fit: BoxFit.cover)),
                  ),
                );
              }

              return ListView.builder(
                  itemCount: value.anotherList.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return customList(
                        QueryArtworkWidget(
                          id: value.anotherList[index].id!,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/logo_music_player-removebg-preview.png',
                            ),
                          ),
                        ),
                        value.anotherList[index].songname!,
                        value.anotherList[index].artist ?? "No Artist",
                        index,
                        context);
                  });
            }),
          ),
        ],
      ),
      // bottomSheet: NowPlayingSlider(),
    );
  }
}
