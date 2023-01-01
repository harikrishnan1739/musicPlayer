// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'FavoriteProvider.dart';
import 'model.dart';
import 'splash.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(SongModelAdapter());
  await Hive.initFlutter();
  await Hive.openBox('favorites');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context)=>FavoriteProvider(),
      child:const  MaterialApp(
        title: 'Music player',
        debugShowCheckedModeBanner: false,
        home: Splash(),
      ),
    );
  }
}
