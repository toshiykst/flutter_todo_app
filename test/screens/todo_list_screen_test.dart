import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo_app/repositories/todo_repository.dart';
import 'package:flutter_todo_app/screens/todo_list_screen/todo_list_screen.dart';
import 'package:flutter_todo_app/screens/todo_list_screen/todo_list_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../fixtures/todo.dart';
import '../utils/screen.dart';
import 'todo_list_screen_test.mocks.dart';

@GenerateMocks([TodoRepository])
void main() {
  late TodoRepository mockTodoRepository;
  final mockUncompletedTodos =
      mockTodos.where((todo) => !todo.completed).toList();
  final mockCompletedTodos = mockTodos.where((todo) => todo.completed).toList();
  final mockUncompletedTodoCount = mockUncompletedTodos.length;
  final mockCompletedTodoCount = mockCompletedTodos.length;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
  });

  group('Uncompleted todo list testing', () {
    testWidgets('Display "No todos" when uncompleted todos do not exist',
        (WidgetTester tester) async {
      when(mockTodoRepository.getTodos()).thenAnswer((_) => Future.value([]));
      await pumpScreen(tester: tester, screen: TodoListScreen(), overrides: [
        todoListProvider
            .overrideWithValue(TodoListViewModel(mockTodoRepository))
      ]);
      expect(find.text('No todos'), findsOneWidget);
    });

    testWidgets('Display todo list when uncompleted todos exist.',
        (WidgetTester tester) async {
      when(mockTodoRepository.getTodos())
          .thenAnswer((_) => Future.value(mockTodos));
      await pumpScreen(tester: tester, screen: TodoListScreen(), overrides: [
        todoListProvider
            .overrideWithValue(TodoListViewModel(mockTodoRepository))
      ]);
      expect(find.text('No todos'), findsNothing);
      expect(find.byKey(const Key('todo-list-item')),
          findsNWidgets(mockUncompletedTodoCount));
    });

    testWidgets('Display the todo form when the plus icon is tapped.',
        (WidgetTester tester) async {
      when(mockTodoRepository.getTodos())
          .thenAnswer((_) => Future.value(mockTodos));
      await pumpScreen(tester: tester, screen: TodoListScreen(), overrides: [
        todoListProvider
            .overrideWithValue(TodoListViewModel(mockTodoRepository))
      ]);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('todo-form')), findsOneWidget);
    });

    testWidgets('Display the todo detail when a todo list item is tapped.',
        (WidgetTester tester) async {
      final targetTodo = mockUncompletedTodos.first;
      when(mockTodoRepository.getTodos())
          .thenAnswer((_) => Future.value(mockTodos));
      when(mockTodoRepository.getTodo(targetTodo.id))
          .thenAnswer((_) => Future.value(targetTodo));
      await pumpScreen(tester: tester, screen: TodoListScreen(), overrides: [
        todoListProvider
            .overrideWithValue(TodoListViewModel(mockTodoRepository))
      ]);
      await tester.tap(find.byKey(const Key('todo-list-item')).first);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('todo-detail')), findsOneWidget);
    });

    testWidgets('Delete the todo item when it is swiped from end to start',
        (WidgetTester tester) async {
      final targetTodo = mockUncompletedTodos.first;
      when(mockTodoRepository.getTodos())
          .thenAnswer((_) => Future.value(mockTodos));
      when(mockTodoRepository.deleteTodo(targetTodo.id))
          .thenAnswer((_) => Future.value());
      await pumpScreen(tester: tester, screen: TodoListScreen(), overrides: [
        todoListProvider
            .overrideWithValue(TodoListViewModel(mockTodoRepository))
      ]);
      expect(find.text(targetTodo.title), findsOneWidget);
      await tester.drag(
          find.byType(Dismissible).first, const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('todo-list-item')),
          findsNWidgets(mockUncompletedTodoCount - 1));
      expect(find.text(targetTodo.title), findsNothing);
      verify(mockTodoRepository.deleteTodo(targetTodo.id)).called(1);
    });

    testWidgets(
        'Move the todo item that is swiped from start to end into completed todo list.',
        (WidgetTester tester) async {
      final targetTodo = mockUncompletedTodos.first;
      final updatedTargetTodo =
          mockUncompletedTodos.first.copyWith(completed: true);
      when(mockTodoRepository.getTodos())
          .thenAnswer((_) => Future.value(mockTodos));
      when(mockTodoRepository.updateTodo(updatedTargetTodo))
          .thenAnswer((_) => Future.value());
      await pumpScreen(tester: tester, screen: TodoListScreen(), overrides: [
        todoListProvider
            .overrideWithValue(TodoListViewModel(mockTodoRepository))
      ]);
      expect(find.text(targetTodo.title), findsOneWidget);
      await tester.drag(
          find.byType(Dismissible).first, const Offset(500.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('todo-list-item')),
          findsNWidgets(mockUncompletedTodoCount - 1));
      expect(find.text(targetTodo.title), findsNothing);
      verify(mockTodoRepository.updateTodo(updatedTargetTodo)).called(1);
      await tester.tap(find.text('completed'));
      await tester.pumpAndSettle();
      expect(find.text(targetTodo.title), findsOneWidget);
      expect(find.byKey(const Key('todo-list-item')),
          findsNWidgets(mockCompletedTodoCount + 1));
    });
  });

  group('Completed todo list testing', () {
    testWidgets(
        'Display "No completed todos" when completed todos do not exist',
        (WidgetTester tester) async {
      when(mockTodoRepository.getTodos())
          .thenAnswer((_) => Future.value(mockUncompletedTodos));
      await pumpScreen(tester: tester, screen: TodoListScreen(), overrides: [
        todoListProvider
            .overrideWithValue(TodoListViewModel(mockTodoRepository))
      ]);
      await tester.tap(find.text('completed'));
      await tester.pumpAndSettle();
      expect(find.text('No completed todos'), findsOneWidget);
    });

    testWidgets('Display todo list when completed todos exist.',
        (WidgetTester tester) async {
      when(mockTodoRepository.getTodos())
          .thenAnswer((_) => Future.value(mockTodos));
      await pumpScreen(tester: tester, screen: TodoListScreen(), overrides: [
        todoListProvider
            .overrideWithValue(TodoListViewModel(mockTodoRepository))
      ]);
      await tester.tap(find.text('completed'));
      await tester.pumpAndSettle();
      expect(find.text('No completed todos'), findsNothing);
      expect(find.byKey(const Key('todo-list-item')),
          findsNWidgets(mockCompletedTodoCount));
    });

    testWidgets('The FloatingActionButton to show the todo form is hidden.',
        (WidgetTester tester) async {
      when(mockTodoRepository.getTodos())
          .thenAnswer((_) => Future.value(mockTodos));
      await pumpScreen(tester: tester, screen: TodoListScreen(), overrides: [
        todoListProvider
            .overrideWithValue(TodoListViewModel(mockTodoRepository))
      ]);
      await tester.tap(find.text('completed'));
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('Display the todo detail when a todo list item is tapped.',
        (WidgetTester tester) async {
      final targetTodo = mockCompletedTodos.first;
      when(mockTodoRepository.getTodos())
          .thenAnswer((_) => Future.value(mockTodos));
      when(mockTodoRepository.getTodo(targetTodo.id))
          .thenAnswer((_) => Future.value(targetTodo));
      await pumpScreen(tester: tester, screen: TodoListScreen(), overrides: [
        todoListProvider
            .overrideWithValue(TodoListViewModel(mockTodoRepository))
      ]);
      await tester.tap(find.text('completed'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('todo-list-item')).first);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('todo-detail')), findsOneWidget);
    });

    testWidgets('Delete the todo item when it is swiped from end to start',
        (WidgetTester tester) async {
      final targetTodo = mockCompletedTodos.first;
      when(mockTodoRepository.getTodos())
          .thenAnswer((_) => Future.value(mockTodos));
      when(mockTodoRepository.deleteTodo(targetTodo.id))
          .thenAnswer((_) => Future.value());
      await pumpScreen(tester: tester, screen: TodoListScreen(), overrides: [
        todoListProvider
            .overrideWithValue(TodoListViewModel(mockTodoRepository))
      ]);
      await tester.tap(find.text('completed'));
      await tester.pumpAndSettle();
      expect(find.text(targetTodo.title), findsOneWidget);
      await tester.drag(
          find.byType(Dismissible).first, const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('todo-list-item')),
          findsNWidgets(mockCompletedTodoCount - 1));
      expect(find.text(targetTodo.title), findsNothing);
      verify(mockTodoRepository.deleteTodo(targetTodo.id)).called(1);
    });

    testWidgets(
        'Move the todo item that is swiped from start to end into uncompleted todo list.',
        (WidgetTester tester) async {
      final targetTodo = mockCompletedTodos.first;
      final updatedTargetTodo =
          mockCompletedTodos.first.copyWith(completed: false);
      when(mockTodoRepository.getTodos())
          .thenAnswer((_) => Future.value(mockTodos));
      when(mockTodoRepository.updateTodo(updatedTargetTodo))
          .thenAnswer((_) => Future.value());
      await pumpScreen(tester: tester, screen: TodoListScreen(), overrides: [
        todoListProvider
            .overrideWithValue(TodoListViewModel(mockTodoRepository))
      ]);
      await tester.tap(find.text('completed'));
      await tester.pumpAndSettle();
      expect(find.text(targetTodo.title), findsOneWidget);
      await tester.drag(
          find.byType(Dismissible).first, const Offset(500.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('todo-list-item')),
          findsNWidgets(mockCompletedTodoCount - 1));
      expect(find.text(targetTodo.title), findsNothing);
      verify(mockTodoRepository.updateTodo(updatedTargetTodo)).called(1);
      await tester.tap(find.text('uncompleted'));
      await tester.pumpAndSettle();
      expect(find.text(targetTodo.title), findsOneWidget);
      expect(find.byKey(const Key('todo-list-item')),
          findsNWidgets(mockUncompletedTodoCount + 1));
    });
  });
}
