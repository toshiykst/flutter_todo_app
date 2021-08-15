import 'package:flutter_todo_app/models/todo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_detail_state.freezed.dart';

@freezed
class TodoDetailState with _$TodoDetailState {
  const factory TodoDetailState({
    Todo? todo,
  }) = _TodoDetailState;
}
