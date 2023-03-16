import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:musicplayer/screen/bottamnavigationbar.dart';
import 'package:musicplayer/screen/homepage.dart';
// import 'package:musicplayer/bottamnavigationbar.dart';
// import 'package:musicplayer/homepage.dart';
// import 'package:musicplayer/screens/homepage.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({super.key});

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  Widget block(String musicName) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 15),
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
            title: Text(
              musicName,
              style: TextStyle(color: Colors.white),
            ),
            trailing: PopupMenuButton(
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
                  removeBox();
                } else if (value == 2) {
                  renameBox();
                }
              },
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
      // backgroundColor: const Color(0xFF3A376A),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('PlayList'),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Container(
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
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 100.0, right: 25),
                  child: IconButton(
                      onPressed: alertBox,
                      icon: const Icon(
                        Icons.add_circle_outline,
                        size: 60,
                      ))),
              SizedBox(
                height: 20,
              ),
              const Text(
                'Create Playlist',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: 5,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) => block('PlayList  $index'),
                  ),
                ),
              ),
            ],
          ),
        ),
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

  void renameBox() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
