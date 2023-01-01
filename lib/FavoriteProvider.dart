import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _item = [];
  List<String> get favs => _item;

  void toggleFavorite(String fav) {
    final isExist = _item.contains(fav);
    if (isExist) {
      _item.remove(fav);
    } else {
      _item.add(fav);
    }
    notifyListeners();
  }

  void clearFavortie() {
    _item = [];
    notifyListeners();
  }

  bool isExist(String fav) {
    final isExist = _item.contains(fav);
    return isExist;
  }

  static FavoriteProvider of(
    BuildContext context, {
    bool listen = true,
  }) {
    return Provider.of<FavoriteProvider>(
      context,
      listen: listen,
    );
  }
}
