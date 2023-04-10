import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/db_funtion/songdb_model.dart';
// import 'package:musicplayer/screen/homescreen.dart';
import 'package:musicplayer/screen/playingscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:text_scroll/text_scroll.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AssetsAudioPlayer _audioPlayersearch = AssetsAudioPlayer.withId('0');
  final box = SongBox.getInstance();
  late List<Songs> dbSongs;

  @override
  void initState() {
    dbSongs = box.values.toList();
    for (var element in dbSongs) {
      allSongs.add(Audio.file(element.songUrl!,
          metas: Metas(
              title: element.songname,
              artist: element.artist,
              id: element.id.toString())));
    }
    super.initState();
  }

  List<Audio> allSongs = [];
  final TextEditingController _searchController = TextEditingController();
  late List<Songs> anotherList = List.from(dbSongs);
  final songbox = SongBox.getInstance();
  Widget searchTextField() {
    return TextFormField(
      onChanged: (value) => searchList(value),
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

  Widget customList(cover, musicName, sub, index) {
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
                  Playlist(audios: allSongs, startIndex: index),
                  headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
                  showNotification: true,
                  loopMode: LoopMode.playlist);
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
    return Scaffold(
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
            child: searchTextField(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 140.0),
            child: ListView.builder(
              itemCount: anotherList.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (ctx, index) => customList(
                  QueryArtworkWidget(
                    id: anotherList[index].id!,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/logo_music_player-removebg-preview.png',
                      ),
                    ),
                  ),
                  anotherList[index].songname!,
                  anotherList[index].artist ?? "No Artist",
                  index),
            ),
          ),
        ],
      ),
    );
  }

  void searchList(String value) {
    setState(
      () {
        anotherList = dbSongs
            .where((element) =>
                element.songname!.toLowerCase().contains(value.toLowerCase()))
            .toList();
        allSongs.clear();
        for (var item in anotherList) {
          allSongs.add(
            Audio.file(
              item.songUrl.toString(),
              metas: Metas(
                artist: item.artist,
                title: item.songname,
                id: item.id.toString(),
              ),
            ),
          );
        }
      },
    );
  }
}
