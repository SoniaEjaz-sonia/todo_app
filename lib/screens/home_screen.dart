import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/provider/todo_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Column(
            children: context
                .watch<TodosProvider>()
                .todos
                .map((todo) => ListTile(
                      leading: Text(todo.id.toString()),
                      title: Text(todo.title),
                      subtitle: Text(todo.date.toString()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () => context.read<TodosProvider>().toggleImp(todo.id),
                                icon: Icon(
                                  Icons.star,
                                  color: todo.isImportant ? Colors.yellow : Colors.grey,
                                )),
                            IconButton(
                                onPressed: () {
                                  context.read<TodosProvider>().deleteTodo(todo);
                                },
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final random = Random();
          final isImportant = random.nextBool();
          final todo = Todo()
            ..title = isImportant ? 'Important task' : 'Normal task'
            ..isImportant = isImportant
            ..date = DateTime.now();
          context.read<TodosProvider>().addTodo(todo);
        },
      ),
    );
  }
}
