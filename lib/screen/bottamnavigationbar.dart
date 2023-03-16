import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:musicplayer/screen/favoratiescreen.dart';
import 'package:musicplayer/screen/homepage.dart';
import 'package:musicplayer/screen/homescreen.dart';
import 'package:musicplayer/screen/libraryscreen.dart';
import 'package:musicplayer/screen/playlistscrren.dart';
import 'package:musicplayer/screen/searchscreen.dart';

// import 'package:musicplayer/screen/homepage/

class BottamNavigationScreen extends StatefulWidget {
  const BottamNavigationScreen({super.key});

  @override
  State<BottamNavigationScreen> createState() => _BottamNavigationScreenState();
}

class _BottamNavigationScreenState extends State<BottamNavigationScreen> {
  late List<Map<String, Widget>> _pages;
  int currentIndex = 0;
  int _selectedPageindex = 0; // final screen = [
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
        'pages': HomePage(),
      },
      {
        'pages': SearchScreen(),
      },
      {
        'pages': LibraryScreen(),
      },
    ];
    super.initState();
  }

  void _selectpage(int index) {
    setState(() {
      _selectedPageindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _pages[_selectedPageindex]['pages'],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 1.5,
        clipBehavior: Clip.antiAlias,
        child: Container(
          color: const Color(0x0006062b),
          height: kBottomNavigationBarHeight * 0.98,
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(0, 8, 8, 199),
              border: Border(
                top: BorderSide(
                  // color: Color(0x0006062b),
                  width: 0,
                ),
              ),
            ),
            child: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: _selectpage,
              backgroundColor: Colors.black,
              unselectedItemColor: const Color.fromARGB(255, 19, 36, 44),
              selectedItemColor: Colors.white,
              currentIndex: _selectedPageindex,
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
                  icon: Icon(null),
                ),
                // BottomNavigationBarItem(
                //   label: 'Playlist',
                //   icon: Icon(Icons.playlist_add),
                // ),
                BottomNavigationBarItem(
                  label: 'Lyibrary',
                  // activeIcon: null,
                  icon: Icon(Icons.library_books_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionButton(
          backgroundColor: Colors.blueGrey.shade800,
          hoverElevation: 20,
          splashColor: Colors.black,
          tooltip: 'Search',
          elevation: 0,
          child: const Icon(Icons.search),
          onPressed: () => setState(
            () {
              _selectedPageindex = 1;
            },
          ),
        ),
      ),
    );
  }
}
