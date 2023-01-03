// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'FavoriteProvider.dart';
import 'model.dart';
import 'splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(SongModelAdapter());
  var dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  await Hive.openBox("favorites");
  //Hive.box('favorites').clear();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoriteProvider(),
      child: const MaterialApp(
        title: 'Música',
        debugShowCheckedModeBanner: false,
        home: Splash(),
      ),
    );
  }
}
