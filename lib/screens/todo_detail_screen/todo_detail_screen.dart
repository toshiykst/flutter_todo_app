import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/todo_detail_screen/todo_detail_view_model.dart';
import 'package:flutter_todo_app/screens/todo_form_screen/todo_form_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoDetailScreen extends HookConsumerWidget {
  final int _todoId;

  const TodoDetailScreen({Key? key, required todoId})
      : _todoId = todoId,
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(todoDetailProvider(_todoId).select((s) => s.todo));

    return Scaffold(
        key: const Key('todo-detail'),
        appBar: AppBar(
          title: const Text('Todo Detail'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Todo',
              onPressed: () async {
                final isEditedTodo = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TodoFormScreen(todo: todo),
                        fullscreenDialog: true));
                if (isEditedTodo) {
                  ref.read(todoDetailProvider(_todoId).notifier).fetchTodo();
                }
              },
            ),
          ],
        ),
        body: todo != null
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      todo.description,
                      style: Theme.of(context).textTheme.headline6,
                    )
                  ],
                ))
            : Center(
                child: Text('Not found'),
              ));
  }
}
