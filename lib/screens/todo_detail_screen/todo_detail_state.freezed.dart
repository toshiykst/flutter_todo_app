// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'todo_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$TodoDetailStateTearOff {
  const _$TodoDetailStateTearOff();

  _TodoDetailState call({Todo? todo}) {
    return _TodoDetailState(
      todo: todo,
    );
  }
}

/// @nodoc
const $TodoDetailState = _$TodoDetailStateTearOff();

/// @nodoc
mixin _$TodoDetailState {
  Todo? get todo => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TodoDetailStateCopyWith<TodoDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodoDetailStateCopyWith<$Res> {
  factory $TodoDetailStateCopyWith(
          TodoDetailState value, $Res Function(TodoDetailState) then) =
      _$TodoDetailStateCopyWithImpl<$Res>;
  $Res call({Todo? todo});

  $TodoCopyWith<$Res>? get todo;
}

/// @nodoc
class _$TodoDetailStateCopyWithImpl<$Res>
    implements $TodoDetailStateCopyWith<$Res> {
  _$TodoDetailStateCopyWithImpl(this._value, this._then);

  final TodoDetailState _value;
  // ignore: unused_field
  final $Res Function(TodoDetailState) _then;

  @override
  $Res call({
    Object? todo = freezed,
  }) {
    return _then(_value.copyWith(
      todo: todo == freezed
          ? _value.todo
          : todo // ignore: cast_nullable_to_non_nullable
              as Todo?,
    ));
  }

  @override
  $TodoCopyWith<$Res>? get todo {
    if (_value.todo == null) {
      return null;
    }

    return $TodoCopyWith<$Res>(_value.todo!, (value) {
      return _then(_value.copyWith(todo: value));
    });
  }
}

/// @nodoc
abstract class _$TodoDetailStateCopyWith<$Res>
    implements $TodoDetailStateCopyWith<$Res> {
  factory _$TodoDetailStateCopyWith(
          _TodoDetailState value, $Res Function(_TodoDetailState) then) =
      __$TodoDetailStateCopyWithImpl<$Res>;
  @override
  $Res call({Todo? todo});

  @override
  $TodoCopyWith<$Res>? get todo;
}

/// @nodoc
class __$TodoDetailStateCopyWithImpl<$Res>
    extends _$TodoDetailStateCopyWithImpl<$Res>
    implements _$TodoDetailStateCopyWith<$Res> {
  __$TodoDetailStateCopyWithImpl(
      _TodoDetailState _value, $Res Function(_TodoDetailState) _then)
      : super(_value, (v) => _then(v as _TodoDetailState));

  @override
  _TodoDetailState get _value => super._value as _TodoDetailState;

  @override
  $Res call({
    Object? todo = freezed,
  }) {
    return _then(_TodoDetailState(
      todo: todo == freezed
          ? _value.todo
          : todo // ignore: cast_nullable_to_non_nullable
              as Todo?,
    ));
  }
}

/// @nodoc

class _$_TodoDetailState implements _TodoDetailState {
  const _$_TodoDetailState({this.todo});

  @override
  final Todo? todo;

  @override
  String toString() {
    return 'TodoDetailState(todo: $todo)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _TodoDetailState &&
            (identical(other.todo, todo) ||
                const DeepCollectionEquality().equals(other.todo, todo)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(todo);

  @JsonKey(ignore: true)
  @override
  _$TodoDetailStateCopyWith<_TodoDetailState> get copyWith =>
      __$TodoDetailStateCopyWithImpl<_TodoDetailState>(this, _$identity);
}

abstract class _TodoDetailState implements TodoDetailState {
  const factory _TodoDetailState({Todo? todo}) = _$_TodoDetailState;

  @override
  Todo? get todo => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$TodoDetailStateCopyWith<_TodoDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}
