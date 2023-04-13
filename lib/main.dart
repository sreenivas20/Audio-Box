import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
// import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicplayer/db_funtion/all_db_functions.dart';
import 'package:musicplayer/db_funtion/favorate_db_model.dart';
import 'package:musicplayer/db_funtion/mostlyplayed.dart';
import 'package:musicplayer/db_funtion/playlistmodel.dart';
import 'package:musicplayer/db_funtion/recentlyplayed.dart';
import 'package:musicplayer/db_funtion/songdb_model.dart';
// import 'package:musicplayer/screen/homescreen.dart';
import 'package:musicplayer/screen/splashscreen.dart';
// import 'package:musicplayer/screens/splashscreen.dart';

// import 'splashscreen.dart';s
// import 'package:musicplayer/screens/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SongsAdapter());
  await Hive.openBox<Songs>(boxName);
  Hive.registerAdapter(FavouritesAdapter());
  openFavouritesDB();
  Hive.registerAdapter(PlaylistSongsAdapter());
  await Hive.openBox<PlaylistSongs>('playlist');
  Hive.registerAdapter(RecentlyPlayedAdapter());
  openRecentlyPlayeddb();
  Hive.registerAdapter(MostPlayedAdapter());
  openMostPlayeddb();
  // await Hive.openBox<MostPlayed>('Mostplayed');
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Audio Box",
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
