import 'dart:convert';

import 'package:flutter_todo_app/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoRepository {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  Future<int> _generateId() async {
    final SharedPreferences prefs = await _prefs;
    final storedTodoStrings = prefs.getStringList('todos');
    if (storedTodoStrings == null || storedTodoStrings.length == 0) {
      return 1;
    }
    final latestTodo = Todo.fromJson(jsonDecode(storedTodoStrings.last));
    return latestTodo.id + 1;
  }

  Future<void> postTodo(String title, String description) async {
    final id = await _generateId();
    final todo = Todo(id: id, title: title, description: description);
    final SharedPreferences prefs = await _prefs;
    await prefs.setStringList(
        'todos', [...?prefs.getStringList('todos'), jsonEncode(todo.toJson())]);
  }

  Future<List<Todo>> fetchTodos() async {
    final SharedPreferences prefs = await _prefs;
    final todoJsonStrings = await prefs.getStringList('todos');
    if (todoJsonStrings == null) return [];
    final todos =
        todoJsonStrings.map((json) => Todo.fromJson(jsonDecode(json))).toList();
    todos.sort((a, b) => b.id.compareTo(a.id));
    return todos;
  }
}
