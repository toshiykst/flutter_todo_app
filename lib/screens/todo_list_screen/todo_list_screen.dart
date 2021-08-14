import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_todo_app/screens/add_todo_form_screen/add_todo_form_screen.dart';
import 'package:flutter_todo_app/screens/todo_list_screen/todo_list_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoListScreen extends HookConsumerWidget {
  const TodoListScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _tabController = useTabController(initialLength: 2, initialIndex: 0);

    final _index = useState(0);

    _tabController.addListener(() {
      _index.value = _tabController.index;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo list'),
        bottom: TabBar(controller: _tabController, tabs: const <Widget>[
          Tab(
            child: const Text('todos'),
          ),
          Tab(
            child: const Text('done'),
          ),
        ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _TodoList(),
          Container(
            child: Text('done todo list'),
          )
        ],
      ),
      floatingActionButton: _index.value == 0
          ? FloatingActionButton(
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
            )
          : null,
    );
  }
}

class _TodoList extends HookConsumerWidget {
  const _TodoList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider
        .select((s) => s.todos.where((todo) => !todo.completed).toList()));

    if (todos.length == 0) {
      return Center(child: Text('No todos'));
    }

    return ListView.builder(
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
                    .updateTodo(todo.copyWith(completed: true));
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
    );
  }
}
