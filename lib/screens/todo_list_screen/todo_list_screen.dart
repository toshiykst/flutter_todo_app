import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/todo_model.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  // TODO: this is mock todo items.
  final List<Todo> todos = List<Todo>.generate(
      30,
      (index) => Todo(
          id: index,
          title: 'title$index',
          description: 'this is my todo$index'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo list'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            title: Text(todo.title),
            trailing: Icon(Icons.more_vert),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  // TODO: Apply later
                  builder: (context) => Text('add todo form'),
                  fullscreenDialog: true));
          // builder: (context) => AddTodoPage(), fullscreenDialog: true));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
