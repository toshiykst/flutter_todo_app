import 'package:flutter/material.dart';
import 'package:flutter_todo_app/repositories/todo_repository.dart';

class AddTodoFormScreen extends StatefulWidget {
  const AddTodoFormScreen({Key? key}) : super(key: key);

  @override
  _AddTodoFormScreenState createState() => _AddTodoFormScreenState();
}

class _AddTodoFormScreenState extends State<AddTodoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add todo'),
        ),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(children: <Widget>[
                  TextFormField(
                    onSaved: (value) {
                      if (value != null) {
                        _title = value;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Title', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    maxLines: 10,
                    onSaved: (value) {
                      if (value != null) {
                        _description = value;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Description', border: OutlineInputBorder()),
                  ),
                  Center(
                      child: ElevatedButton(
                          child: const Text('Submit'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                              try {
                                await TodoRepository()
                                    .postTodo(_title, _description);
                              } catch (e) {
                                print(e.toString());
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Row(children: [
                                      const Icon(Icons.check_circle,
                                          color: Colors.white),
                                      const SizedBox(width: 10),
                                      const Text('added todo')
                                    ])),
                              );
                              Navigator.of(context).pop(true);
                            }
                          }))
                ]))));
  }
}
