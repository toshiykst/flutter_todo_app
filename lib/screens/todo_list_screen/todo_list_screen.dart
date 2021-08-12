import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/add_todo_form_screen/add_todo_form_screen.dart';
import 'package:flutter_todo_app/screens/todo_list_screen/todo_list_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoListScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider.select((s) => s.todos));
    print(todos);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo list'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.startToEnd,
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.startToEnd) {
                  ref
                      .read(todoListProvider.notifier)
                      .updateTodo(todo.copyWith(done: true));
                }
              },
              background: Container(
                color: Colors.green,
                child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ],
                    )),
              ),
              child: ListTile(
                title: Text(todo.title),
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final isAddedTodo = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTodoFormScreen(),
                  fullscreenDialog: true));

          if (isAddedTodo) {
            ref.read(todoListProvider.notifier).fetchTodos();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
