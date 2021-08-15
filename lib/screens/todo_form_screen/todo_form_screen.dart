import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_todo_app/repositories/todo_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoFormScreen extends HookConsumerWidget {
  const TodoFormScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = useMemoized(() => GlobalKey<FormState>());
    final _titleController = useTextEditingController();
    final _descriptionController = useTextEditingController();

    final _handleSubmit = useCallback(() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState?.save();
      try {
        await TodoRepository()
            .postTodo(_titleController.text, _descriptionController.text);
      } catch (e) {
        print(e.toString());
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.green,
            content: Row(children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              const Text('added todo')
            ])),
      );
      Navigator.of(context).pop(true);
    }, [_formKey]);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add todo'),
        ),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Title', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Description', border: OutlineInputBorder()),
                  ),
                  Center(
                      child: ElevatedButton(
                          child: const Text('Submit'),
                          onPressed: _handleSubmit))
                ]))));
  }
}
