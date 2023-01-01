  import 'package:hive_flutter/adapters.dart';
  part 'model.g.dart';
@HiveType(typeId: 0)
class SongModel {
  @HiveField(0)
  late final String? songname;
  @HiveField(1)
  late final String? artistname;
  @HiveField(2)
  late final String? id;

  SongModel({
    required this.songname,
    required this.artistname,
    this.id,
  });
}
