import 'package:isar/isar.dart';

part 'todo.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement;

  late String title;

  late DateTime date;

  late bool isDone = false;

  late bool isImportant = false;
}
