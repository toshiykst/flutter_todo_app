import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo_app/models/todo.dart';
import 'package:flutter_todo_app/repositories/todo_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fixtures/todo.dart';

void setMockTodos(List<Todo> todos) {
  SharedPreferences.setMockInitialValues({
    'todos': [...todos].map((todo) => jsonEncode(todo.toJson())).toList()
  });
}

void main() {
  late TodoRepository todoRepository;

  setUpAll(() {
    todoRepository = TodoRepository();
    setMockTodos(mockTodos);
  });

  test('getTodo testing', () async {
    final expectedTodo = mockTodos.first;

    final todo = await todoRepository.getTodo(expectedTodo.id);

    expect(todo, equals(expectedTodo));
  });

  test('getTodos testing', () async {
    final expectedTodos = [...mockTodos]..sort((a, b) => b.id.compareTo(a.id));

    final todos = await todoRepository.getTodos();

    expect(todos, equals(expectedTodos));
  });

  test('postTodo testing', () async {
    final expectedTitle = 'postedTitle';
    final expectedDescription = 'postedDescription';

    await todoRepository.postTodo(expectedTitle, expectedDescription);

    final prefs = await SharedPreferences.getInstance();

    final postedTodo =
        Todo.fromJson(jsonDecode(prefs.getStringList('todos')!.last));

    expect(postedTodo.title, equals(expectedTitle));
    expect(postedTodo.description, equals(expectedDescription));
  });

  test('updateTodo testing', () async {
    final expectedTodo = mockTodo.copyWith(
        title: 'updatedTitle', description: 'updatedDescription');

    await todoRepository.updateTodo(expectedTodo);

    final prefs = await SharedPreferences.getInstance();

    final updatedTodo = prefs
        .getStringList('todos')!
        .map((todoString) => Todo.fromJson(jsonDecode(todoString)))
        .toList()
        .firstWhere((todo) => todo.id == expectedTodo.id);

    expect(updatedTodo, equals(expectedTodo));
  });

  test('deleteTodo testing', () async {
    final expectedTodo = mockTodos.last;

    final prefs = await SharedPreferences.getInstance();
    final storedTodoCount = prefs.getStringList('todos')!.length;

    await todoRepository.deleteTodo(expectedTodo.id);

    final deletedTodo = prefs
        .getStringList('todos')!
        .map((todoString) => Todo.fromJson(jsonDecode(todoString)))
        .toList()
        .firstWhereOrNull((todo) => todo.id == expectedTodo.id);

    final expectedStoreTodoCount = prefs.getStringList('todos')!.length;
    expect(deletedTodo, isNull);
    expect(expectedStoreTodoCount, equals(storedTodoCount - 1));
  });
}
