import 'package:flutter_todo_app/models/todo.dart';
import 'package:flutter_todo_app/repositories/todo_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final todoFormProvider = Provider((_) => TodoFormViewModel(TodoRepository()));

class TodoFormViewModel {
  final TodoRepository _repository;

  bool _isLoading = false;

  TodoFormViewModel(this._repository);

  Future<void> addTodo(String title, String description) async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      await _repository.postTodo(title, description);
    } catch (e) {
      throw Exception('Failed add todo.');
    }
    _isLoading = false;
  }

  Future<void> updateTodo(Todo? todo) async {
    if (todo == null) {
      throw Exception('todo must be provided.');
    }
    if (_isLoading) return;
    _isLoading = true;
    try {
      await _repository.updateTodo(todo);
    } catch (e) {
      throw Exception('Failed update todo.');
    }
    _isLoading = false;
  }
}
