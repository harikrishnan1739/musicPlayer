// ignore_for_file: unnecessary_brace_in_string_interps
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
    buildFoodShimmer();
  }

  @override
  void dispose() {
    buildFoodShimmer();
    requestPermission();
    super.dispose();
  }

  // ignore: unused_field
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

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
                icon: const Icon(Icons.favorite_border),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search_outlined,
                  size: 27,
                ),
              ),
            ),
          )
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
        builder: (context, box, child) {
          // ignore: unused_local_variable
          return FutureBuilder<List<SongModel>>(
            future: _audioQuery.querySongs(
                sortType: null,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true),
            builder: (context, item) {
              // ignore: unused_local_variable
              final isFavorite = box.get(item) != null;

              if (item.data == null) {
                return Center(
                  child: ListView.builder(
                    itemCount: item.data?.length,
                    itemBuilder: (context, index) {
                      return buildFoodShimmer();
                    },
                  ),
                );
              }
              if (item.data!.isEmpty) {
                return const Center(
                  child: Text('☹ \n No songs found',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                );
              }

              return ListView.builder(
                itemBuilder: (context, index) {
                  var fav = item.data?[index].title ?? '';
                  print("!!!!!!!!!!!!!!!!!!!!!!${item.data![index]}");
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
                      onPressed: () {
                        provider.toggleFavorite(fav);
                      },
                      icon: provider.isExist(fav)
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

  Widget buildFoodShimmer() => ListView.builder(
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
  void requestPermission() {
    Permission.storage.request();
  }
}
