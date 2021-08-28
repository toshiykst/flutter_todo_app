import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo_app/repositories/todo_repository.dart';
import 'package:flutter_todo_app/screens/todo_form_screen/todo_form_screen.dart';
import 'package:flutter_todo_app/screens/todo_form_screen/todo_form_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../fixtures/todo.dart';
import '../utils/screen.dart';
import 'todo_form_screen_test.mocks.dart';

@GenerateMocks([TodoRepository])
void main() {
  late TodoRepository mockTodoRepository;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
  });

  group('todo form testing', () {
    group('add todo form', () {
      testWidgets('Display "Add Todo" when the todo prop is not provided.',
          (WidgetTester tester) async {
        await pumpScreen(tester: tester, screen: TodoFormScreen(), overrides: [
          todoFormProvider
              .overrideWithValue(TodoFormViewModel(mockTodoRepository))
        ]);

        expect(find.text('Add todo'), findsOneWidget);
      });

      testWidgets('Show error message when field inputs are invalid',
          (WidgetTester tester) async {
        await pumpScreen(tester: tester, screen: TodoFormScreen(), overrides: [
          todoFormProvider
              .overrideWithValue(TodoFormViewModel(mockTodoRepository))
        ]);

        await tester.enterText(find.widgetWithText(TextFormField, 'Title'), '');
        await tester.enterText(
            find.widgetWithText(TextFormField, 'Description'), '');
        await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
        await tester.pump();

        expect(find.text('Please enter some text'), findsNWidgets(2));
      });

      testWidgets('Successfully submitted.', (WidgetTester tester) async {
        final inputTitle = 'Added title';
        final inputDescription = 'Added description';

        when(mockTodoRepository.postTodo(inputTitle, inputDescription))
            .thenAnswer((_) => Future.value(null));

        await pumpScreen(tester: tester, screen: TodoFormScreen(), overrides: [
          todoFormProvider
              .overrideWithValue(TodoFormViewModel(mockTodoRepository))
        ]);

        await tester.enterText(
            find.widgetWithText(TextFormField, 'Title'), inputTitle);
        await tester.enterText(
            find.widgetWithText(TextFormField, 'Description'),
            inputDescription);
        await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
        await tester.pump();

        expect(find.text('Please enter some text'), findsNothing);
        verify(mockTodoRepository.postTodo(inputTitle, inputDescription))
            .called(1);
        expect(find.text('This todo is added'), findsOneWidget);
      });
    });

    group('edit todo form', () {
      testWidgets(
          'Display "Edit Todo" and initial values are provided todo values when the todo prop is provided.',
          (WidgetTester tester) async {
        await pumpScreen(
            tester: tester,
            screen: TodoFormScreen(
              todo: mockTodo,
            ),
            overrides: [
              todoFormProvider
                  .overrideWithValue(TodoFormViewModel(mockTodoRepository))
            ]);

        final titleFieldFinder = find.widgetWithText(TextFormField, 'Title');
        final titleFieldInitialValue =
            tester.widget<TextFormField>(titleFieldFinder).initialValue;

        final descriptionFieldFinder =
            find.widgetWithText(TextFormField, 'Description');
        final descriptionInitialValue =
            tester.widget<TextFormField>(descriptionFieldFinder).initialValue;

        expect(find.text('Edit todo'), findsOneWidget);
        expect(titleFieldInitialValue, equals(mockTodo.title));
        expect(descriptionInitialValue, equals(mockTodo.description));
      });

      testWidgets('Show error message when field inputs are invalid',
          (WidgetTester tester) async {
        await pumpScreen(
            tester: tester,
            screen: TodoFormScreen(
              todo: mockTodo,
            ),
            overrides: [
              todoFormProvider
                  .overrideWithValue(TodoFormViewModel(mockTodoRepository))
            ]);

        await tester.enterText(find.widgetWithText(TextFormField, 'Title'), '');
        await tester.enterText(
            find.widgetWithText(TextFormField, 'Description'), '');
        await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
        await tester.pump();

        expect(find.text('Please enter some text'), findsNWidgets(2));
      });

      testWidgets('Successfully submitted.', (WidgetTester tester) async {
        final inputTitle = 'Updated title';
        final inputDescription = 'Updated description';
        final updatedTodo =
            mockTodo.copyWith(title: inputTitle, description: inputDescription);

        when(mockTodoRepository.updateTodo(updatedTodo))
            .thenAnswer((_) => Future.value(null));

        await pumpScreen(
            tester: tester,
            screen: TodoFormScreen(
              todo: mockTodo,
            ),
            overrides: [
              todoFormProvider
                  .overrideWithValue(TodoFormViewModel(mockTodoRepository))
            ]);

        await tester.enterText(
            find.widgetWithText(TextFormField, 'Title'), inputTitle);
        await tester.enterText(
            find.widgetWithText(TextFormField, 'Description'),
            inputDescription);
        await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
        await tester.pump();

        expect(find.text('Please enter some text'), findsNothing);
        verify(mockTodoRepository.updateTodo(updatedTodo)).called(1);
        expect(find.text('This todo is updated'), findsOneWidget);
      });
    });
  });
}
