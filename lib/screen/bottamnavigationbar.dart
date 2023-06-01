// import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:musicplayer/screen/favoratiescreen.dart';
// import 'package:musicplayer/screen/homepage.dart';
import 'package:musicplayer/screen/homescreen.dart';
import 'package:musicplayer/screen/libraryscreen.dart';
// import 'package:musicplayer/screen/playlistscrren.dart';
import 'package:musicplayer/screen/searchscreen.dart';

// import 'package:musicplayer/screen/homepage/
ValueNotifier<int> indexChangeNotifier = ValueNotifier(0);

class BottamNavigationScreen extends StatefulWidget {
  const BottamNavigationScreen({super.key});

  @override
  State<BottamNavigationScreen> createState() => _BottamNavigationScreenState();
}

class _BottamNavigationScreenState extends State<BottamNavigationScreen> {
  late List<Map<String, Widget>> _pages;
  int currentIndex = 0;
   // final screen = [
  //   HomeScreen(),
  //   SearchScreen(),
  //   FavoriteScreen(),
  //   PlayListScreen(),
  //   LibraryScreen(),
  // ];
  @override
  void initState() {
    _pages = [
      {
        'pages':  HomePage(),
      },
      {
        'pages':  SearchScreen(),
      },
      {
        'pages': const LibraryScreen(),
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: indexChangeNotifier,
        builder: (context, int newIndex, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: _pages[newIndex]['pages'],
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(0.0),
              child: BottomNavigationBar(
                selectedFontSize: 0.0,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                onTap: (index) {
                  indexChangeNotifier.value = index;
                },
                backgroundColor: Colors.black,
                unselectedItemColor: const Color.fromARGB(255, 28, 53, 64),
                selectedItemColor: Colors.white,
                currentIndex: newIndex,
                items: const [
                  BottomNavigationBarItem(
                    label: 'Home',
                    icon: Icon(Icons.home),
                  ),
                  // BottomNavigationBarItem(
                  //   label: 'Liked Songs',
                  //   icon: Icon(Icons.favorite_outline),
                  // ),
                  BottomNavigationBarItem(
                    activeIcon: null,
                    label: 'Search',
                    icon: Icon(Icons.search),
                  ),
                  // BottomNavigationBarItem(
                  //   label: 'Playlist',
                  //   icon: Icon(Icons.playlist_add),
                  // ),
                  BottomNavigationBarItem(
                    label: 'Lyibrary',
                    // activeIcon : null,
                    icon: Icon(Icons.library_books_rounded),
                  ),
                ],
              ),
            ),
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.miniCenterDocked,
            // floatingActionButton: Padding(
            //   padding: const EdgeInsets.all(0.0),
            //   child: FloatingActionButton(
            //     shape: const CircleBorder(),
            //     backgroundColor: Colors.blueGrey.shade800,
            //     hoverElevation: 20,
            //     splashColor: Colors.black,
            //     tooltip: 'Search',
            //     elevation: 0,
            //     child: const Icon(
            //       Icons.search,
            //       color: Colors.white,
            //     ),
            //     onPressed: () => setState(
            //       () {
            //         newIndex = 1;
            //       },
            //     ),
            //   ),
            // ),
          );
        });
  }
}
