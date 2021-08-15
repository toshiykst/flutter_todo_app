import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/todo_detail_screen/todo_detail_view_model.dart';
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
        appBar: AppBar(
          title: const Text('Todo Detail'),
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
