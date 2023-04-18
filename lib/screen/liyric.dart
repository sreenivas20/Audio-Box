import 'dart:convert';
import 'dart:developer';
// import 'dart:developer';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:musicplayer/screen/homescreen.dart';

// void lyricSheet(BuildContext context) async {
//   String lyrics = await fetchLyrics(
//       audioPlayer2.getCurrentAudioTitle, audioPlayer2.getCurrentAudioArtist);
//   // ignore: use_build_context_synchronously
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         // title: Text(songName + " - " + artistName),
//         content: Text(lyrics),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Close"),
//           ),
//         ],
//       );
//     },
//   );
// }

// Future<String> fetchLyrics(String songName, String artistName) async {
//   const apiKey = '58a70da8cdc77786c71b21cb68e0c552';
//   if (songName.isEmpty || artistName.isEmpty) {
//     throw Exception('Song name or artist name is empty');
//   }
//   final response = await http.get(Uri.parse(
//       'https://api.musixmatch.com/ws/1.1/matcher.lyrics.get?apikey=$apiKey&q_track=$songName&q_artist=$artistName'));
//   if (response.statusCode == 200) {
//     final lyricsResponse = json.decode(response.body);
//     // log(lyricsResponse);
//     print('Lyrics response: ${lyricsResponse.runtimeType}');
//     final lyrics = lyricsResponse['message']['body']['lyrics']['lyrics_body'];
//     return lyrics;
//   } else {
//     throw Exception('Failed to fetch lyrics');
//   }
// }

Future<String> fetchLyrics(String trackName, String artistName) async {
  const apiKey = '3d1ba7f7e5ef3cafdbf02b3b4fcc2f8a';
  // final trackNameEncoded = Uri.encodeComponent(trackName);
  // final artistNameEncoded = Uri.encodeComponent(artistName);
  final response = await http.get(Uri.parse(
      'https://api.musixmatch.com/ws/1.1/matcher.lyrics.get?apikey=$apiKey&q_track=$trackName&q_artist=$artistName'));
  if (response.statusCode == 200) {
    final lyricsResponse = jsonDecode(response.body);
    log('dgsdgv');
    final lyrics = lyricsResponse['message']['body']['lyrics']['lyrics_body'];
    log('fegff');
    return lyrics;
  } else {
    throw Exception('Failed to fetch lyrics');
  }
}

void getLyrics(context) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(.7),
        contentTextStyle: const TextStyle(color: Colors.white),
        content: FutureBuilder(
          future: fetchLyrics(audioPlayer2.getCurrentAudioTitle,
              audioPlayer2.getCurrentAudioArtist),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(snapshot.data!),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
                child: const Center(
                  child: Text(
                    'Failed to load lyrics',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            } else {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                ),
              );
            }
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ]),
  );
}
