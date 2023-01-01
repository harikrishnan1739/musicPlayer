import 'package:flutter/material.dart';

import 'FavoriteProvider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final fav = provider.favs;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios_new)),
        backgroundColor: Colors.transparent,
        title: const Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: fav.length,
        itemBuilder: (context, index) {
          final favs = fav[index];
          return ListTile(
            onTap: () {},
            title: Text(
              favs,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: IconButton(
              onPressed: () {
                provider.toggleFavorite(favs);
              },
              icon: provider.isExist(favs)
                  ? const Icon(Icons.favorite, color: Colors.red)
                  : const Icon(Icons.favorite_border),
            ),
          );
        },
      ),
    );
  }
}
