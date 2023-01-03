// ignore_for_file: unnecessary_brace_in_string_interps, unused_local_variable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player/musicplayfield.dart';
import 'package:music_player/shimmer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:shimmer/shimmer.dart';

import 'package:music_player/FavoriteProvider.dart';

import 'favsongs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  @override
  void dispose() {
    requestPermission();
    super.dispose();
  }

  // ignore: unused_field
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();
  var box = Hive.box('favorites');

  var songsList = [];
  int currentIndex = 0;
  playSong(String? uri) {
    try {
      _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(uri!),
        ),
      );
      _audioPlayer.play();
    } on Exception {
      // ignore: avoid_print
      print('Error pasing song');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        leading: null,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.00),
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritePage(),
                    ),
                  );
                },
                icon: const Icon(Icons.favorite_border,color: Colors.red,),
              ),
            ),
            
          ),
        ],
        title: Text(
          'My Playlist',
          style: GoogleFonts.biryani(
            color: Colors.white,
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('favorites').listenable(),
        // ignore: duplicate_ignore
        builder: (context, box, child) {
          return FutureBuilder<List<SongModel>>(
            future: _audioQuery.querySongs(
                sortType: null,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true),
            builder: (context, item) {
              // ignore: unused_local_variable

              if (item.data == null) {
                return Center(
                  child: ListView.builder(
                    itemCount: item.data?.length,
                    itemBuilder: (context, index) {
                      return const Center(
                          child: Text(
                        'Empty Songs',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ));
                    },
                  ),
                );
              }
              if (item.data!.isEmpty) {
                return const Center(
                    child: Text(
                  'Empty Songs',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ));
              }

              return ListView.builder(
                itemBuilder: (context, index) {
                  final fav = item.data?[index].title ?? '';
                  return ListTile(
                    tileColor: Colors.black,
                    textColor: const Color.fromARGB(255, 255, 255, 255),
                    iconColor: const Color.fromARGB(255, 87, 199, 126),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NowPlaying(
                            songModel: item.data![index],
                            audioPlayer: _audioPlayer,
                            songsList: item.data,
                            currentIndex: index,
                          ),
                        ),
                      );
                    },
                    leading: const Icon(
                      Icons.music_note_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    title: Text("${item.data?[index].title}",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold)),
                    subtitle: Text("${item.data?[index].artist}",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 110, 231, 152),
                            fontWeight: FontWeight.w500)),
                    trailing: IconButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        var isfavorite = box.get(index) != null;

                        if (isfavorite) {
                          await box.delete(index);
                          const snackBar = SnackBar(
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 236, 51, 9),
                            animation: kAlwaysCompleteAnimation,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            content: Text("Removed Successfully"),
                          );
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          await box.put(index, fav);

                          const snackBar = SnackBar(
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 64, 249, 47),
                            animation: kAlwaysCompleteAnimation,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            content: Text("Added Successfully"),
                          );
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        print(
                            "TRUE OR FALSE FIELD  : ${provider.isExistItemInHive(index)}");
                        print("PUT INDEX number : ${index}");
                      },
                      icon: provider.isExistItemInHive(index)
                          ? const Icon(Icons.favorite, color: Colors.red)
                          : const Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            ),
                    ),
                  );
                },
                itemCount: item.data!.length,
              );
            },
          );
        },
      ),
    );
  }

  Future<void> buildFoodShimmer() async {
    await Future.delayed(Duration(seconds: 3));
    ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: ShimmerWidget.circular(
          width: 64,
          height: 64,
          shapeBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        title: const ShimmerWidget.rectangular(height: 16),
        subtitle: const ShimmerWidget.rectangular(height: 14),
      ),
      itemCount: 10,
    );
  }

  void requestPermission() {
    Permission.storage.request();
  }
}
