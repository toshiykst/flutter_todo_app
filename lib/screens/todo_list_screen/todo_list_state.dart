import 'package:flutter_todo_app/models/todo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_list_state.freezed.dart';
part 'todo_list_state.g.dart';

@freezed
class TodoListState with _$TodoListState {
  const factory TodoListState({
    @Default([]) List<Todo> todos,
  }) = _TodoListState;

  factory TodoListState.fromJson(Map<String, dynamic> json) =>
      _$TodoListStateFromJson(json);
}
