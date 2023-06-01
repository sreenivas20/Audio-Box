import 'dart:developer';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer/application/favorate_provider.dart';
import 'package:musicplayer/application/homescreen.dart';
import 'package:musicplayer/application/playlist_provider.dart';
import 'package:musicplayer/db_funtion/all_db_functions.dart';
import 'package:musicplayer/db_funtion/mostlyplayed.dart';
import 'package:musicplayer/db_funtion/playlistmodel.dart';
import 'package:musicplayer/db_funtion/recentlyplayed.dart';
import 'package:musicplayer/db_funtion/songdb_model.dart';
import 'package:musicplayer/screen/aboutus.dart';
import 'package:musicplayer/screen/favoratiescreen.dart';
import 'package:musicplayer/screen/functions/createplaylist.dart';
import 'package:musicplayer/screen/nowplaying_slider.dart';
import 'package:musicplayer/screen/playingscreen.dart';
import 'package:musicplayer/screen/playlistscrren.dart';
import 'package:musicplayer/screen/popup.dart';
import 'package:musicplayer/screen/recentlyplayed.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'mostlyplayed.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  final playlistbox = PlaylistSongsbox.getInstance();

  final List<PlaylistSongs> playlistsong1 = [];

  // List<Audio> convertedAudios = [];
  final songbox1 = SongBox.getInstance();

  List<Audio> reaudioList = [];

  

  final _audioQuery = new OnAudioQuery();

  // final AudioPlayer _audioPlayer = AudioPlayer();
  List<SongModel> allSongs = [];

  var size, height, width;

  Widget customList(String? musicName, imagecover, String sub, index,
      allDbsongs, rsongs, mostsong, context) {
    final dbPro = Provider.of<FavoriteProvider>(context);
    // MostPlayed mostsong = allmostplayedsong[index];
    Songs songs = allDbsongs[index];
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 0),
      child: Container(
        width: 390,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 25, 35, 40),
              Color.fromARGB(255, 24, 33, 38),
              Colors.transparent,
              // Colors.orange
            ],
           
          ),
        ),
        child: Center(
          child: ListTile(
            onTap: () {
              PlayingScreen.playingNowIndex.value = index;
              audioPlayer2.open(
                  Playlist(
                      audios: HomeScreenProvider.convertedAudios,
                      startIndex: index),
                  headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
                  showNotification: true,
                  loopMode: LoopMode.playlist);
              // setState(() {});
              Navigator.of(context).push(CupertinoPageRoute(
                  fullscreenDialog: true, builder: (ctx) => PlayingScreen()));
              rsongs = RecentlyPlayed(
                  id: songs.id,
                  artist: songs.artist,
                  duration: songs.duration,
                  songurl: songs.songUrl,
                  songname: songs.songname,
                  index: index);
              NowPlayingSlider.enteredvalue.value = index;
              recentlyPlayedFunction(rsongs);
              updateSongPlayedCount(mostsong, index);
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
                  onPressed: () async {
                    PlayingScreen.playingNowIndex.value = index;
                    audioPlayer2.open(
                      Playlist(
                          audios: HomeScreenProvider.convertedAudios,
                          startIndex: index),
                      headPhoneStrategy:
                          HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
                      showNotification: true,
                    );
                  },
                  // ignore: prefer_const_constructors
                  icon: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
                PopupMenuButton(
                  color: Colors.white,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            dbPro.checkFavoritesStatus(songs.id, BuildContext)
                                ? const Icon(
                                    Icons.favorite_outline,
                                  )
                                : const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                            const SizedBox(
                              width: 5,
                            ),
                            dbPro.checkFavoritesStatus(songs.id, BuildContext)
                                ? const Text(
                                    'Add to favourite',
                                    style: TextStyle(color: Colors.red),
                                  )
                                : const Text('Remove ',
                                    style: TextStyle(color: Colors.red))
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.playlist_add),
                            SizedBox(
                              width: 6,
                            ),
                            Text('Add to playlist'),
                          ],
                        ),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 1) {
                      if (dbPro.checkFavoritesStatus(songs.id, BuildContext)) {
                        dbPro.addToFavourite(songs.id);

                        const snackBar = SnackBar(
                          duration: Duration(milliseconds: 500),
                          content: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Added To Favouraites',
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
                      } else if (!dbPro.checkFavoritesStatus(
                          songs.id, BuildContext)) {
                        dbPro.removeFavSong(songs.id);
                        const snackBar = SnackBar(
                          duration: Duration(milliseconds: 500),
                          content: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.favorite_outline,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
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
                          padding:  EdgeInsets.only(top: 10, bottom: 15),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        // isFavorite = false;
                        log('${allDbSongs[index].songname}');
                      }

                      // setState(() {
                      //   isFavorite = !isFavorite;
                      // });
                    } else if (value == 2) {
                      bottomSheetfun(index, context);
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

  void alertBox(context) {
    final myController = TextEditingController(text: 'Playlist');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Create Playlist"),
        content: TextField(
          controller: myController,
          decoration: const InputDecoration(
            labelText: 'Enter the Name of Playlist',
          ),
          style: const TextStyle(color: Colors.black),
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
                  createplaylist(myController.text, context);
                  Provider.of<PlayListProvider>(context, listen: false)
                      .playListFunction();
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

  void quitBox(context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Quit "),
        content: const Text('Are you sure'),
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
                  SystemNavigator.pop();
                },
                child: const Text(
                  "Quit",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    log("Builder");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PlayListProvider>(context, listen: false).playListFunction();
    });
    Provider.of<HomeScreenProvider>(context).initFunction();
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      // bottomSheet: NowPlayingSlider(),

      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.blueGrey.shade900,
        child: ListView(
          // padding: const EdgeInsets.only(top: 50),
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(color: Colors.blueGrey.shade900),
              child: const Center(
                child: Text(
                  'Settings',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            const Divider(
              thickness: 1,
            ), //DrawerHeader
            ListTile(
              leading: const Icon(Icons.privacy_tip, color: Colors.white),
              title: const Text(
                ' Privacy and Policy ',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Settingmenupopup(
                          mdFilename: 'privacypolicy.md',
                          title: "Privacy Policy",
                        )));
                // Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book, color: Colors.white),
              title: const Text(
                ' About Us ',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AboutUs(),
                ));
                // Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.workspace_premium, color: Colors.white),
              title: const Text(
                ' Terms and condition ',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Settingmenupopup(
                          mdFilename: 'termsandconditons.md',
                          title: "Terms & Conditions",
                        )));
                // Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.white),
              title: const Text(
                ' Share ',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                const urllink = 'apps.audiobox.musicplayer';
                await Share.share(urllink);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                'Quit',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                quitBox(context);
              },
            ),
            SizedBox(
              height: height * 0.65,
              child: const Center(
                child: Text(
                  "Version\n \t 1.0.0",
                  style: TextStyle(color: Colors.white38),
                ),
              ),
            )
          ],
        ),
      ),
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          // height: double.infinity,
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

          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 110,
                ),
                Container(
                  height: height * 0.190,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 20),
                          child: Column(
                            children: [
                              Container(
                                width: width * 0.450,
                                height: height * 0.150,
                                child: InkWell(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (ctx) => PlayListScreen())),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'assets/playstlist image.jpeg',
                                            ))),
                                  ),
                                ),
                              ),
                              // boxSize(10, 0),
                              const Text(
                                'PlayList',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 1, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: width * 0.450,
                                height: height * 0.150,
                                child: InkWell(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (ctx) => FavoriteScreen())),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'assets/liked images.png',
                                            ))),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 30.0),
                                child: Text(
                                  'Liked Songs',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            children: [
                              Container(
                                width: width * 0.450,
                                height: height * 0.150,
                                child: InkWell(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              MostlyPlayedScreen())),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'assets/Mostly played.jpeg',
                                            ))),
                                  ),
                                ),
                              ),
                              const Text(
                                'Mostly Played',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            children: [
                              Container(
                                width: width * 0.450,
                                height: height * 0.150,
                                child: InkWell(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              const RecentlyPlayedScreen())),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'assets/recently-played.png',
                                            ))),
                                  ),
                                ),
                              ),
                              const Text(
                                'Recently Played',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 22.0, top: 10, bottom: 10, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        'Songs',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      GestureDetector(
                        onTap: () {
                          PlayingScreen.playingNowIndex.value = playingIndex;
                          audioPlayer2.open(
                              Playlist(
                                  audios: HomeScreenProvider.convertedAudios,
                                  startIndex: playingIndex),
                              headPhoneStrategy:
                                  HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
                              showNotification: true,
                              loopMode: LoopMode.playlist);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => PlayingScreen()));
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          maxRadius: 25,
                          child: Icon(
                            Icons.play_arrow,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Container(
                    child:
                        // List<Songs> allDbsongs = allsongbox.values.toList();

                        Consumer<HomeScreenProvider>(
                      builder: ((context, value, child) {
                        log('counsumer');
                        final dbPro = Provider.of<HomeScreenProvider>(context);
                        final music = value.dbSongs;
                        if (dbPro.dbSongs.isEmpty) {
                          const Center(
                            child: Text('Songs Not Fount'),
                          );
                        } else {
                          return ListView.builder(
                            padding: EdgeInsets.only(top: 10),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: value.dbSongs.length,
                            itemBuilder: ((context, index) {
                              RecentlyPlayed? rsongs;
                              MostPlayed mostsong = allmostplayedsong[index];

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: customList(
                                    music[index].songname!,
                                    QueryArtworkWidget(
                                      id: music[index].id!,
                                      type: ArtworkType.AUDIO,
                                      nullArtworkWidget: ClipRRect(
                                        child: Image.asset(
                                            'assets/logo_music_player-removebg-preview.png'),
                                      ),
                                    ),
                                    music[index].artist ?? "No Artist",
                                    index,
                                    music,
                                    rsongs,
                                    mostsong,
                                    context),
                              );
                            }),
                          );
                        }

                        return CircularProgressIndicator();
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void bottomSheetfun(songindex, context) {
    final box = PlaylistSongsbox.getInstance();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: height * 0.400,
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
                      onPressed: () {
                        alertBox(context);
                      },
                      icon: const Center(
                        child: Icon(
                          Icons.add_circle_outline,
                          size: 50,
                        ),
                      )),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Create playlist'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ValueListenableBuilder<Box<PlaylistSongs>>(
                        valueListenable: box.listenable(),
                        builder: (context, playlistsongs, child) {
                          List<PlaylistSongs> playlistsong =
                              playlistsongs.values.toList();
                          return playlistsong.isNotEmpty
                              ? Container(
                                  child: ListView.builder(
                                    itemCount: playlistsong.length,
                                    // physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: ((context, index) {
                                      return block(
                                          playlistsong[index].platlistname!,
                                          context,
                                          index,
                                          playlistsongs,
                                          songindex,
                                          playlistsong);
                                    }),
                                  ),
                                )
                              : const Center(
                                  child:
                                      Text("You haven't created any playlist"));
                        }),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget block(String musicName, context, index, playlistsongs, songindex,
      playlistsong) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 30, right: 20),
      child: Container(
        width: 360,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 25, 35, 40),
              Color.fromARGB(255, 24, 33, 38),
              // Colors.orange
            ],
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
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              PlaylistSongs? playsongs = playlistsongs.getAt(index);
              List<Songs> playsongdb = playsongs!.playlistsongs!;
              List<Songs> songdb = songbox.values.toList();
              bool isAddedAlreaded = playsongdb
                  .any((element) => element.id == songdb[songindex].id);
              if (!isAddedAlreaded) {
                playsongdb.add(
                  Songs(
                    songname: songdb[songindex].songname,
                    artist: songdb[songindex].artist,
                    duration: songdb[songindex].duration,
                    songUrl: songdb[songindex].songUrl,
                    id: songdb[songindex].id,
                  ),
                );
              }
              playlistsongs.putAt(
                  index,
                  PlaylistSongs(
                      platlistname: playlistsong[index].platlistname,
                      playlistsongs: playsongdb));
              log('song added to ${playlistsong[index].platlistname}');
              Navigator.pop(context);
              final snackBar = SnackBar(
                duration: const Duration(seconds: 1),
                content: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.playlist_add,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Added to ${playlistsong[index].platlistname}',
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
                padding: const EdgeInsets.only(top: 10, bottom: 15),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            trailing: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: PopupMenuButton(
                color: Colors.white,
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Remove Playlist'),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text('Rename playlist'),
                    )
                  ];
                },
                onSelected: (value) {
                  if (value == 1) {
                    removeBox(index, context);
                  } else if (value == 2) {
                    renameBox(context, index);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void renameBox(context, index) {
    final playlistbox = PlaylistSongsbox.getInstance();
    List<PlaylistSongs> playlistsong = playlistbox.values.toList();
    final textEditmyController =
        TextEditingController(text: playlistsong[index].platlistname);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Rename Playlist"),
        content: TextField(
          controller: textEditmyController,
          decoration: const InputDecoration(
            labelText: 'Enter the new Name of Playlist',
          ),
          style: const TextStyle(color: Colors.black),
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
                  editPlayList(textEditmyController.text, index);
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

  void removeBox(index, context) {
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
                  deletePlaylist(index);
                  Provider.of<PlayListProvider>(context, listen: false)
                      .playListFunction();
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
}

// 
final int playingIndex = 0;
final alldbsongs = SongBox.getInstance();
List<Songs> allDbSongs = alldbsongs.values.toList();
final songbox = SongBox.getInstance();
final AssetsAudioPlayer audioPlayer2 = AssetsAudioPlayer.withId('0');
List<MostPlayed> allmostplayedsong = mostPlayedSongs.values.toList();
