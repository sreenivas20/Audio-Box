import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:musicplayer/screen/favoratiescreen.dart';
import 'package:musicplayer/screen/mostlyplayed.dart';
// import 'package:musicplayer/favoratiescreen.dart';
// import 'package:musicplayer/playingscreen.dart';
import 'package:musicplayer/screen/playingscreen.dart';
import 'package:musicplayer/screen/playlistscrren.dart';
import 'package:musicplayer/screen/recentlyplayed.dart';
// import 'package:musicplayer/searchscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  Widget recentlyPlayed(String musicName) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/logo music player.png',
                    ))),
          ),
          const Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              'Music',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget mostlyPlayed(String musicName) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/logo music player.png',
                    ))),
          ),
          Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              musicName,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget boxSize(double? hei, double? wid) {
    return SizedBox(
      height: hei,
      width: wid,
    );
  }

  Widget customList(musicName) {
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
              style: TextStyle(color: Colors.white),
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 1,
                    child: Text('Remove Playlist'),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text('Add to playlist'),
                  ),
                ];
              },
              // onSelected: (value) {
              //   if (value == 1) {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //           builder: (context) => BottamNavigationScreen()),
              //     );
              //   } else if (value == 2) {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //           builder: (context) => BottamNavigationScreen()),
              //     );
              //   }
              // },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF3A376A),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: const Text(''),
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 25),
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PlayingScreen(),
                  )),
              icon: const Icon(
                Icons.music_note,
                color: Colors.white,
              ))
        ],
        backgroundColor: Colors.transparent,
      ),
      // drawer: Drawer(child: Li),

      body: Stack(children: [
        Container(
          // color: const Color(0x0006062b),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.blueGrey.shade300,
            Colors.black,
            Colors.black,
            Colors.black
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        ),
        

        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: ListView(scrollDirection: Axis.horizontal, children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 10, right: 30),
              child: Column(
                children: [
                  Container(
                    width: 150,
                    height: 120,
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const PlayListScreen())),
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
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 1, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    height: 120,
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
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
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 10, right: 10),
              child: Column(
                children: [
                  Container(
                    width: 150,
                    height: 120,
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const MostlyPlayedScreen())),
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
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 10, right: 10),
              child: Column(
                children: [
                  Container(
                    width: 150,
                    height: 120,
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const RecentlyPlayedScreen())),
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
                    'Recently Played',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            ),
          ]),
        ),
        Positioned(
          top: 250,
          left: 26,
          child: Container(
            width: 500,
            height: 200,
            child: const Text(
              'Songs',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 280.0),
          child: Container(
            height: 1000,
           
            child: ListView.builder(
              itemCount: 10,
              padding: const EdgeInsets.only(top: 30),
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => customList('music'),
            ),
          ),
        ),
      ]),
    );
  }
}
