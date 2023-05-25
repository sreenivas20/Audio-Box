import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:musicplayer/screen/homescreen.dart';

Future<String> fetchLyrics(String trackName, String artistName) async {
  const apiKey = '3d1ba7f7e5ef3cafdbf02b3b4fcc2f8a';
  final response = await http.get(Uri.parse(
      'https://api.musixmatch.com/ws/1.1/matcher.lyrics.get?apikey=$apiKey&q_track=$trackName&q_artist=$artistName'));
  if (response.statusCode == 200) {
    final lyricsResponse = jsonDecode(response.body);
    final lyrics = lyricsResponse['message']['body']['lyrics']['lyrics_body'];
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
