import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer/db_funtion/recentlyplayed.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:text_scroll/text_scroll.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

class RecentlyPlayedScreen extends StatefulWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  State<RecentlyPlayedScreen> createState() => _RecentlyPlayedScreenState();
}

class _RecentlyPlayedScreenState extends State<RecentlyPlayedScreen> {
  bool _isFavorite = false;

  void _onFavoriteButtonPress() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  final List<RecentlyPlayed> recentplay = [];
  final box = RecentlyPlayedBox.getInstance();
  List<Audio> rcentplay = [];
  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer.withId('0');
  @override
  void initState() {
    // TODO: implement initState
    final List<RecentlyPlayed> recentlyplayed =
        box.values.toList().reversed.toList();
    for (var item in recentlyplayed) {
      rcentplay.add(
        Audio.file(
          item.songurl.toString(),
          metas: Metas(
            artist: item.artist,
            title: item.songname,
            id: item.id.toString(),
          ),
        ),
      );
    }
    super.initState();
  }


  Widget customList(cover, musicName, sub, recentIndex) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 15, right: 20),
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
              _audioPlayer.open(
                Playlist(audios: rcentplay, startIndex: recentIndex),
                headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
                showNotification: true,
              );
            },
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(10), child: cover),
            title: TextScroll(
              musicName,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: TextScroll(
              sub,
              style: TextStyle(color: Colors.white),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PopupMenuButton(
                  color: Colors.white,
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 1,
                        child: Text('Remove songs'),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 1) {
                      removeBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget boxSize(double? hei, double? wid) {
    return SizedBox(
      height: hei,
      width: wid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Recently Played',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueGrey.shade300,
                Colors.black,
                Colors.black,
                Colors.black
              ],
            ),
          ),
          child: Container(
            child: ValueListenableBuilder<Box<RecentlyPlayed>>(
                valueListenable: box.listenable(),
                builder: ((context, Box<RecentlyPlayed> recentDb, chlid) {
                  List<RecentlyPlayed> Recentplayed =
                      recentDb.values.toList().reversed.toList();
                  return Recentplayed.isNotEmpty
                      ? ListView.builder(
                          itemCount: Recentplayed.length,
                          itemBuilder: ((context, recentIndex) {
                            return customList(
                                QueryArtworkWidget(
                                  keepOldArtwork: true,
                                  id: Recentplayed[recentIndex].id!,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: ClipRRect(
                                    child: Image.asset(
                                        'assets/logo_music_player-removebg-preview.png'),
                                  ),
                                ),
                                Recentplayed[recentIndex].songname!,
                                Recentplayed[recentIndex].artist ?? "No Artist",
                                recentIndex);
                          }),
                        )
                      : const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "You Have't played any songs",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                })),
          ),
        ),
      ),
    );
  }

  void bottomSheetfun() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: alertBox,
                      icon: const Center(
                        child: Icon(
                          Icons.add_circle_outline,
                          size: 50,
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 18.0),
                    child: Text('Create playlist'),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: 2,
                        itemBuilder: (ctx, index) =>
                            bottomSheet('Playlist $index')),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget bottomSheet(musicName) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 15),
      child: Container(
        width: 320,
        height: 70,
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
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/logo music player.png',
                width: 65,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              musicName,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: _onFavoriteButtonPress,
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_outline,
                      color: Colors.white,
                    )),
                PopupMenuButton(
                  color: Colors.white,
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 1,
                        child: Text('Remove Playlist'),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Text('Remane playlist'),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 1) {
                      removeBox();
                    } else if (value == 2) {
                      renameBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void renameBox() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Rename Playlist"),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Enter the new Name of Playlist',
          ),
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text(
                  "Rename",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void removeBox() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Remove "),
        content: Text('Are you sure'),
        actions: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text(
                  "Remove",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void alertBox() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Create Playlist"),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Enter the Name of Playlist',
          ),
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text(
                  "Create",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
