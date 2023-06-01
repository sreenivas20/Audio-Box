import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musicplayer/application/favorate_provider.dart';
import 'package:musicplayer/application/favoritepage_provider.dart';
import 'package:musicplayer/application/homescreen.dart';
import 'package:musicplayer/application/mostlyplated_provider.dart';
import 'package:musicplayer/application/playlist_provider.dart';
import 'package:musicplayer/application/recently_provider.dart';
import 'package:musicplayer/application/search_provider.dart';
import 'package:musicplayer/application/splashscreen_provider.dart';
// import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicplayer/db_funtion/all_db_functions.dart';
import 'package:musicplayer/db_funtion/favorate_db_model.dart';
import 'package:musicplayer/db_funtion/mostlyplayed.dart';
import 'package:musicplayer/db_funtion/playlistmodel.dart';
import 'package:musicplayer/db_funtion/recentlyplayed.dart';
import 'package:musicplayer/db_funtion/songdb_model.dart';
// import 'package:musicplayer/screen/homescreen.dart';
import 'package:musicplayer/screen/splashscreen.dart';
import 'package:provider/provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SplashScreenProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeScreenProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoriteProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoritePageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RecentlyPlayedProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MostlyPlayedProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlayListProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Audio Box",
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
