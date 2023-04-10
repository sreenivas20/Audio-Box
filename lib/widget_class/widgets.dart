// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:musicplayer/screen/playingscreen.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// class WidgetClass extends StatefulWidget {
//   const WidgetClass({super.key});

//   @override
//   State<WidgetClass> createState() => _WidgetClassState();
// }

// class _WidgetClassState extends State<WidgetClass> {
//   final _audioQuery = new OnAudioQuery();
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isFavorite = false;
//   var size, height, width;

//   void _onFavoriteButtonPress() {
//     setState(() {
//       _isFavorite = !_isFavorite;
//     });
//   }

//   void bottomSheetfun() {
//     showModalBottomSheet<void>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           height: height * 0.500,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(25.0),
//               topRight: Radius.circular(25.0),
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Padding(
//               padding: const EdgeInsets.only(right: 20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   IconButton(
//                       onPressed: alertBox,
//                       icon: const Center(
//                         child: Icon(
//                           Icons.add_circle_outline,
//                           size: 50,
//                         ),
//                       )),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.only(left: 18.0),
//                     child: Text('Create playlist'),
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                         itemCount: 2,
//                         itemBuilder: (ctx, index) =>
//                             bottomSheet('Playlist $index')),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void alertBox() {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Create Playlist"),
//         content: const TextField(
//           decoration: InputDecoration(
//             labelText: 'Enter the Name of Playlist',
//           ),
//           style: TextStyle(color: Colors.black),
//         ),
//         actions: <Widget>[
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//                 child: const Text(
//                   "Cancel",
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//                 child: const Text(
//                   "Create",
//                   style: TextStyle(color: Colors.green),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void renameBox() {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Rename Playlist"),
//         content: const TextField(
//           decoration: InputDecoration(
//             labelText: 'Enter the new Name of Playlist',
//           ),
//           style: TextStyle(color: Colors.black),
//         ),
//         actions: <Widget>[
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//                 child: const Text(
//                   "Cancel",
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//                 child: const Text(
//                   "Rename",
//                   style: TextStyle(color: Colors.green),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget bottomSheet(musicName) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10.0, left: 15),
//       child: Container(
//         width: 320,
//         height: 70,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           gradient: const LinearGradient(
//             colors: [
//               Color.fromARGB(255, 25, 35, 40),
//               Color.fromARGB(255, 24, 33, 38),
//             ],
//           ),
//         ),
//         child: Center(
//           child: ListTile(
//             leading: ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.asset(
//                 'assets/logo music player.png',
//                 width: 65,
//                 height: 50,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             title: Text(
//               musicName,
//               style: const TextStyle(color: Colors.white),
//             ),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                     onPressed: _onFavoriteButtonPress,
//                     icon: Icon(
//                       _isFavorite ? Icons.favorite : Icons.favorite_outline,
//                       color: Colors.white,
//                     )),
//                 PopupMenuButton(
//                   color: Colors.white,
//                   itemBuilder: (context) {
//                     return [
//                       const PopupMenuItem(
//                         value: 1,
//                         child: Text('Remove Playlist'),
//                       ),
//                       const PopupMenuItem(
//                         value: 2,
//                         child: Text('Remane playlist'),
//                       ),
//                     ];
//                   },
//                   onSelected: (value) {
//                     if (value == 1) {
//                       removeBox();
//                     } else if (value == 2) {
//                       renameBox();
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void removeBox() {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Remove "),
//         content: Text('Are you sure'),
//         actions: <Widget>[
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//                 child: const Text(
//                   "Cancel",
//                   style: TextStyle(color: Colors.blue),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//                 child: const Text(
//                   "Remove",
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     size = MediaQuery.of(context).size;
//     height = size.height;
//     width = size.width;

//     return const Placeholder();
//   }
// }
