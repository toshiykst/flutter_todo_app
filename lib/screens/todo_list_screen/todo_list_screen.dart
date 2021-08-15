import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_todo_app/models/todo.dart';
import 'package:flutter_todo_app/screens/todo_detail_screen/todo_detail_screen.dart';
import 'package:flutter_todo_app/screens/todo_form_screen/todo_form_screen.dart';
import 'package:flutter_todo_app/screens/todo_list_screen/todo_list_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoListScreen extends HookConsumerWidget {
  const TodoListScreen({
    Key? key,
  }) : super(key: key);

  Future<void> _handleTabTodo(Todo todo, BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TodoDetailScreen(
            todoId: todo.id,
          ),
        ));
  }

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
            child: const Text('uncompleted'),
          ),
          Tab(
            child: const Text('completed'),
          ),
        ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _UncompletedTodoList(
            onTabTodo: _handleTabTodo,
          ),
          _CompletedTodoList(
            onTabTodo: _handleTabTodo,
          ),
        ],
      ),
      floatingActionButton: _index.value == 0
          ? FloatingActionButton(
              onPressed: () async {
                final isAddedTodo = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TodoFormScreen(),
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

class _UncompletedTodoList extends HookConsumerWidget {
  final Future<void> Function(Todo todo, BuildContext context) _onTabTodo;

  const _UncompletedTodoList({Key? key, required onTabTodo})
      : this._onTabTodo = onTabTodo,
        super(key: key);

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
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.startToEnd) {
                ref
                    .read(todoListProvider.notifier)
                    .updateTodo(todo.copyWith(completed: true));
              }
              if (direction == DismissDirection.endToStart) {
                ref.read(todoListProvider.notifier).deleteTodo(todo.id);
              }
            },
            background: Container(
              color: Colors.green,
              child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ],
                  )),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ],
                  )),
            ),
            child: ListTile(
              title: Text(todo.title),
              onTap: () {
                _onTabTodo(todo, context);
              },
            ));
      },
    );
  }
}

class _CompletedTodoList extends HookConsumerWidget {
  final Future<void> Function(Todo todo, BuildContext context) _onTabTodo;

  const _CompletedTodoList({Key? key, required onTabTodo})
      : this._onTabTodo = onTabTodo,
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider
        .select((s) => s.todos.where((todo) => todo.completed).toList()));

    if (todos.length == 0) {
      return Center(child: Text('No completed todos'));
    }

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Dismissible(
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.startToEnd) {
                ref
                    .read(todoListProvider.notifier)
                    .updateTodo(todo.copyWith(completed: false));
              }
              if (direction == DismissDirection.endToStart) {
                ref.read(todoListProvider.notifier).deleteTodo(todo.id);
              }
            },
            background: Container(
              color: Colors.grey,
              child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.undo,
                        color: Colors.white,
                      ),
                    ],
                  )),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ],
                  )),
            ),
            child: ListTile(
              onTap: () {
                _onTabTodo(todo, context);
              },
              title: Text(todo.title),
            ));
      },
    );
  }
}
