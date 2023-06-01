import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musicplayer/screen/favoratiescreen.dart';
import 'package:musicplayer/screen/mostlyplayed.dart';
import 'package:musicplayer/screen/playlistscrren.dart';
import 'package:musicplayer/screen/recentlyplayed.dart';
// import 'package:musicplayer/bottamnavigationbar.dart';
// import 'package:musicplayer/favoratiescreen.dart';
// import 'package:musicplayer/playlistscrren.dart';
// import 'package:musicplayer/recentlyplayed.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  Widget myListTile(Widget ledIcon, String title, Widget trailIcon) {
    return ListTile(
      leading: ledIcon,
      title: Text(
        title,
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
      trailing: trailIcon,
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
      // appBar: AppBar(
      //   elevation: 0,
      //   title: const Padding(
      //     padding: EdgeInsets.all(30.0),
      //     child: Text(
      //       'My Library',
      //       style: TextStyle(fontSize: 30),
      //     ),
      //   ),
      //   backgroundColor: Colors.transparent,
      // ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.blueGrey.shade300,
          Colors.black,
          Colors.black,
          Colors.black
        ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30.0, left: 30, bottom: 10),
              child: Text(
                'MyLibrary',
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.white,
            ),
            myListTile(
              const Icon(
                Icons.playlist_add,
                size: 30,
                color: Colors.white,
              ),
              'Playlist',
              IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) =>  PlayListScreen())),
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
            boxSize(10, 0),
            myListTile(
              const Icon(
                Icons.recent_actors,
                size: 30,
                color: Colors.white,
              ),
              'Recently played',
              IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const RecentlyPlayedScreen())),
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
            boxSize(10, 0),
            myListTile(
              const Icon(
                Icons.favorite_outline,
                size: 30,
                color: Colors.white,
              ),
              'Liked Songs',
              IconButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => FavoriteScreen())),
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
            boxSize(10, 0),
            myListTile(
              const Icon(
                Icons.playlist_add_check,
                size: 30,
                color: Colors.white,
              ),
              'Mostly Played',
              IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) =>  MostlyPlayedScreen())),
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
