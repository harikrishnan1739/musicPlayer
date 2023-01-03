import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'FavoriteProvider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  var box = Hive.box('favorites');
  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final fav = provider.box.values;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        backgroundColor: Colors.transparent,
        title: const Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: fav.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {},
            leading: const Icon(
              Icons.music_note_outlined,
              color: Colors.white,
              size: 30,
            ),
            title: Text(box.getAt(index),
                style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold)),
            trailing: IconButton(
              onPressed: () {
                provider.clearFavortie(index);
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
              },
              icon: provider.isExistItemInHiveFav(index)
                  ? const Icon(Icons.favorite, color: Colors.red)
                  : const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
            ),
          );
        },
      ),
    );
  }
}
