import 'package:flutter_todo_app/repositories/todo_repository.dart';
import 'package:flutter_todo_app/screens/todo_detail_screen/todo_detail_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final todoDetailProvider =
    StateNotifierProvider.family<TodoDetailViewModel, TodoDetailState, int>(
        (ref, id) => TodoDetailViewModel(id: id, repository: TodoRepository()));

class TodoDetailViewModel extends StateNotifier<TodoDetailState> {
  final int _todoId;
  final TodoRepository _repository;

  bool _isLoading = false;

  TodoDetailViewModel({required int id, required TodoRepository repository})
      : _todoId = id,
        _repository = repository,
        super(TodoDetailState()) {
    fetchTodo();
  }

  Future<void> fetchTodo() async {
    if (_isLoading) return;

    _isLoading = true;

    final todo = await _repository.getTodo(_todoId);

    state = state.copyWith(todo: todo);

    _isLoading = false;
  }
}
