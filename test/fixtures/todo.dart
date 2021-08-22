import 'package:flutter_todo_app/models/todo.dart';

final List<Todo> mockTodos = List.generate(
    10,
    (index) => Todo(
        id: index, title: 'title$index', description: 'description$index', completed: index % 2 == 0));
