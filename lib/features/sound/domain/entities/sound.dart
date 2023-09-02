import 'package:isar/isar.dart';

part 'sound.g.dart';

@Collection()
class Sound {
  Id id = Isar.autoIncrement;
  late double volume;
  late bool vibrationEnabled;
}
