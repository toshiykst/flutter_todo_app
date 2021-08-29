import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_todo_app/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoRepository {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  Future<int> _generateId() async {
    final todos = await _getStoredTodos();
    if (todos.length == 0) return 1;
    final latestTodo = todos.last;
    return latestTodo.id + 1;
  }

  Future<List<Todo>> _getStoredTodos() async {
    final SharedPreferences prefs = await _prefs;
    final storedTodoStrings = prefs.getStringList('todos');

    if (storedTodoStrings == null || storedTodoStrings.length == 0) {
      return [];
    }
    return storedTodoStrings
        .map((todoString) => Todo.fromJson(jsonDecode(todoString)))
        .toList();
  }

  Future<Todo?> _getStoredTodo(int id) async {
    final todos = await _getStoredTodos();
    return todos.firstWhereOrNull((todo) => todo.id == id);
  }

  Future<void> postTodo(String title, String description) async {
    final id = await _generateId();
    final todo = Todo(id: id, title: title, description: description);
    final SharedPreferences prefs = await _prefs;
    await prefs.setStringList(
        'todos', [...?prefs.getStringList('todos'), jsonEncode(todo.toJson())]);
  }

  Future<Todo?> getTodo(int id) async {
    return await _getStoredTodo(id);
  }

  Future<List<Todo>> getTodos() async {
    final todos = await _getStoredTodos();
    todos.sort((a, b) => b.id.compareTo(a.id));
    return todos;
  }

  Future<void> updateTodo(Todo todo) async {
    final todos = await _getStoredTodos();
    final SharedPreferences prefs = await _prefs;
    await prefs.setStringList('todos',
        todos.map((v) => jsonEncode(v.id == todo.id ? todo : v)).toList());
  }

  Future<void> deleteTodo(int id) async {
    final todos = await _getStoredTodos();
    final SharedPreferences prefs = await _prefs;
    await prefs.setStringList(
        'todos',
        todos
            .where((todo) => todo.id != id)
            .map((todo) => jsonEncode(todo))
            .toList());
  }
}
