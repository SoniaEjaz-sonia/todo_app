import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/models/todo.dart';

class TodosProvider with ChangeNotifier {
  TodosProvider() {
    init();
  }

  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Isar? isar;

  void init() async {
    final dir = await getApplicationDocumentsDirectory();

    isar ??= await Isar.open(
      [TodoSchema],
      directory: dir.path,
    );

    await isar!.txn(() async {
      final todosCollection = isar!.todos;
      _todos = await todosCollection.where().findAll();
      notifyListeners();
    });
  }

  void addTodo(Todo todo) async {
    await isar!.writeTxn(() async {
      await isar!.todos.put(todo);
    });
    _todos.add(todo);
    notifyListeners();
  }

  void deleteTodo(Todo todo) async {
    await isar!.writeTxn(() async {
      bool deleted = await isar!.todos.delete(todo.id);
      if (deleted) _todos.remove(todo);
      notifyListeners();
    });
  }

  void toggleImp(int id) async {
    await isar!.writeTxn(() async {
      Todo? todo = await isar!.todos.get(id);
      todo!.isImportant = !todo.isImportant;
      await isar!.todos.put(todo);
      int todoIndex = todos.indexWhere((todo) => todo.id == id);
      todos[todoIndex].isImportant = todo.isImportant;
      notifyListeners();
    });
  }
}
