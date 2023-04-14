import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer/db_funtion/playlistmodel.dart';

import 'package:musicplayer/screen/functions/createplaylist.dart';

import 'package:musicplayer/screen/playlistsongsscreen.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({super.key});

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  final playlistbox = PlaylistSongsbox.getInstance();
  late List<PlaylistSongs> playlistsong = playlistbox.values.toList();
  final List<PlaylistSongs> playlistsong1 = [];

  Widget block(String musicName, context, index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 15, right: 20),
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
          // begin: Alignment.topLeft,
          // end: Alignment.bottomRight,
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
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => PlayListSongsList(
                            playindex: index,
                            playlistname: musicName,
                          ))));
            },
            title: Text(
              musicName,
              style: TextStyle(color: Colors.white),
            ),
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
                    removeBox(index);
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

  Widget boxSize(double? hei, double? wid) {
    return SizedBox(
      height: hei,
      width: wid,
    );
  }

  var size, height, width;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('PlayList', style: TextStyle(color: Colors.white)),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
      ),
      body: Stack(children: [
        Container(
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
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 130, right: 25),
                    child: IconButton(
                        onPressed: () => alertBox(),
                        icon: const Icon(Icons.add_circle_outline,
                            size: 60, color: Colors.black))),
                const Padding(
                  padding: EdgeInsets.only(top: 0, right: 26),
                  child: Text(
                    'Create Playlist',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ValueListenableBuilder<Box<PlaylistSongs>>(
                      valueListenable: playlistbox.listenable(),
                      builder: (context, playlistsongs, child) {
                        List<PlaylistSongs> playlistsong =
                            playlistsongs.values.toList();
                        return playlistsong.isNotEmpty
                            ? Container(
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(8.0),
                                  itemCount: playlistsong.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: ((context, index) {
                                    return block(
                                        playlistsong[index].platlistname!,
                                        context,
                                        index);
                                  }),
                                ),
                              )
                            : const Center(
                                child: Padding(
                                padding: EdgeInsets.only(top: 250.0),
                                child: Text(
                                  "You haven't created any playlist",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ));
                      }),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void alertBox() {
    final myController = TextEditingController(text: 'Playlist');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Create Playlist"),
        content: TextField(
          controller: myController,
          decoration: InputDecoration(
              labelText: 'Enter the Name of Playlist',
              border: InputBorder.none),
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
                  createplaylist(myController.text, context);
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

  void renameBox(BuildContext context, int index) {
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

  void removeBox(index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Remove Playlist"),
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
