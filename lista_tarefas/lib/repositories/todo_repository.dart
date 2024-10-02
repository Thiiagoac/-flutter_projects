import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';

const keyTodo = 'todo';

class TodoRepository {
  late SharedPreferences sharedPreferences;

  void saveList(List<Todo> tarefas) {
    final jsonString = json.encode(tarefas);
    sharedPreferences.setString(keyTodo, jsonString);
  }

  void removeTask() {
    sharedPreferences.remove(keyTodo);
  }

  void updateList() {}

  Future<List<Todo>> getList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String listString = sharedPreferences.getString('todo') ?? '[]';
    List lista = json.decode(listString) as List;
    return lista.map((e) => Todo.fromJson(e)).toList();
  }
}
