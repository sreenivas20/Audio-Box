import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  Widget searchTextField() {
    return TextFormField(
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
      // onChanged: (value) {
      //   _searchStudent(value);
      // },
    );
  }

  void clearText() {
    _searchController.clear();
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF3A376A),
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
              padding: const EdgeInsets.all(15.0),
              child: searchTextField(),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 100.0),
            //   child: Opacity(
            //     opacity: 0.5,
            //     child: Container(
            //       height: 300,
            //       width: 450,
            //       decoration: BoxDecoration(
            //         gradient: LinearGradient(colors: [
            //           Colors.blueGrey.shade300,
            //           Colors.black,
            //           Colors.black,
            //           Colors.black
            //         ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            //         color: Colors.black,
            //         borderRadius: BorderRadius.only(
            //             bottomLeft: Radius.circular(40),
            //             bottomRight: Radius.circular(40)),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 120.0),
              child: ListView.builder(
                  itemCount: 4,
                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, index) => customList('music')),
            )
          ],
        ),
      ),
    );
  }
}
