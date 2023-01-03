// ignore_for_file: unnecessary_brace_in_string_interps
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class FavoriteProvider extends ChangeNotifier {
  var box = Hive.box("favorites");
  Box get index => box;

  Future<void> clearFavortie(int index) async {
    final indexKey = box.keyAt(index);
    box.delete(indexKey);
    notifyListeners();
  }

  bool isExistItemInHive(int index) {
    final isExistInHive = box.containsKey(index);
    box.get(index);
    return isExistInHive;
  }

  bool isExistItemInHiveFav(int index) {
    final keyIndex = box.keyAt(index);
    final isExistInHive = box.containsKey(keyIndex);
    box.get(index);
    return isExistInHive;
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
