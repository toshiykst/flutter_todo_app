// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TodoListState _$_$_TodoListStateFromJson(Map<String, dynamic> json) {
  return _$_TodoListState(
    todos: (json['todos'] as List<dynamic>?)
            ?.map((e) => Todo.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$_$_TodoListStateToJson(_$_TodoListState instance) =>
    <String, dynamic>{
      'todos': instance.todos,
    };
