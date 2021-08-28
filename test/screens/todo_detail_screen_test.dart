import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo_app/repositories/todo_repository.dart';
import 'package:flutter_todo_app/screens/todo_detail_screen/todo_detail_screen.dart';
import 'package:flutter_todo_app/screens/todo_detail_screen/todo_detail_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../fixtures/todo.dart';
import '../utils/screen.dart';
import 'todo_detail_screen_test.mocks.dart';

@GenerateMocks([TodoRepository])
void main() {
  late TodoRepository mockTodoRepository;
  final mockTodoId = mockTodo.id;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
  });

  group('todo detail testing', () {
    testWidgets('Display "Not found" when the todo does not exist.',
        (WidgetTester tester) async {
      when(mockTodoRepository.getTodo(mockTodoId))
          .thenAnswer((_) => Future.value(null));

      await pumpScreen(
          tester: tester,
          screen: TodoDetailScreen(todoId: mockTodoId),
          overrides: [
            todoDetailProvider.overrideWithProvider((id) =>
                StateNotifierProvider((_) => TodoDetailViewModel(
                    id: id, repository: mockTodoRepository))),
          ]);
      await tester.pumpAndSettle();

      expect(find.text('Not found'), findsOneWidget);
    });

    testWidgets('Display todo information.', (WidgetTester tester) async {
      when(mockTodoRepository.getTodo(mockTodoId))
          .thenAnswer((_) => Future.value(mockTodo));
      await pumpScreen(
          tester: tester,
          screen: TodoDetailScreen(todoId: mockTodoId),
          overrides: [
            todoDetailProvider.overrideWithProvider((id) =>
                StateNotifierProvider((_) => TodoDetailViewModel(
                    id: id, repository: mockTodoRepository))),
          ]);
      await tester.pumpAndSettle();

      expect(find.text(mockTodo.title), findsOneWidget);
      expect(find.text(mockTodo.description), findsOneWidget);
    });

    testWidgets('Show the edit todo form when the edit icon is tapped.',
        (WidgetTester tester) async {
      when(mockTodoRepository.getTodo(mockTodoId))
          .thenAnswer((_) => Future.value(mockTodo));
      await pumpScreen(
          tester: tester,
          screen: TodoDetailScreen(todoId: mockTodoId),
          overrides: [
            todoDetailProvider.overrideWithProvider((id) =>
                StateNotifierProvider((_) => TodoDetailViewModel(
                    id: id, repository: mockTodoRepository))),
          ]);
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Edit Todo'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('todo-form')), findsOneWidget);
    });
  });
}
