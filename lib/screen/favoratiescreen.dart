import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:musicplayer/screen/playingscreen.dart';
// import 'package:musicplayer/playingscreen.dart';

class FavoriteScreen extends StatefulWidget {
  FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool _isFavorite = false;

  void _onFavoriteButtonPress() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Liked Songs'),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios)),
      ),
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
          // Opacity(
          //   opacity: 0.5,
          //   child: Container(
          //     height: 300,
          //     width: 450,
          //     decoration: const BoxDecoration(
          //         color: Color(0xFF06062B),
          //         borderRadius: BorderRadius.only(
          //             bottomLeft: Radius.circular(40),
          //             bottomRight: Radius.circular(40))),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 130, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Liked Songs',
                  style: TextStyle(color: Colors.white, fontSize: 26),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 40, bottom: 28),
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.play_circle_filled,
                        color: Colors.blueGrey.shade800,
                        size: 60,
                      )),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: ListView.separated(
                padding: EdgeInsets.only(top: 10),
                itemBuilder: (((context, index) {
                  return ListTile(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => PlayingScreen())),
                    title: const Text(
                      'Music',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    trailing: IconButton(
                        onPressed: _onFavoriteButtonPress,
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_outline,
                          color: Colors.white,
                        )),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/logo music player.png',
                        width: 65,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                })),
                separatorBuilder: (((context, index) {
                  return const Divider(
                    thickness: 0.1,
                  );
                })),
                itemCount: 20),
          )
        ],
      ),
    );
  }
}
