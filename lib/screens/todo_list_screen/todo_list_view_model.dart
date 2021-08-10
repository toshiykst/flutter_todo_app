import 'package:flutter_todo_app/repositories/todo_repository.dart';
import 'package:flutter_todo_app/screens/todo_list_screen/todo_list_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final todoListProvider =
    StateNotifierProvider<TodoListViewModel, TodoListState>(
        (_) => TodoListViewModel(TodoRepository()));

class TodoListViewModel extends StateNotifier<TodoListState> {
  final TodoRepository _repository;

  bool _isLoading = false;

  TodoListViewModel(this._repository) : super(TodoListState()) {
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    if (_isLoading) return;

    _isLoading = true;

    final todos = await _repository.getTodos();

    state = state.copyWith(todos: todos);

    _isLoading = false;
  }
}
