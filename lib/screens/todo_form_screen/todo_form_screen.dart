import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_todo_app/models/todo.dart';
import 'package:flutter_todo_app/screens/todo_form_screen/todo_form_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoFormScreen extends HookConsumerWidget {
  const TodoFormScreen({
    Key? key,
    Todo? todo,
  })  : this._todo = todo,
        super(key: key);

  final Todo? _todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = useMemoized(() => GlobalKey<FormState>());
    final _titleController = useTextEditingController(text: _todo?.title ?? '');
    final _descriptionController =
        useTextEditingController(text: _todo?.description ?? '');

    Future<void> _addTodo() async {
      await ref
          .read(todoFormProvider)
          .addTodo(_titleController.text, _descriptionController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        _SucceedSnackBar('This todo is added'),
      );
    }

    Future<void> _updateTodo() async {
      await ref.read(todoFormProvider).updateTodo(_todo!.copyWith(
            title: _titleController.text,
            description: _descriptionController.text,
          ));
      ScaffoldMessenger.of(context).showSnackBar(
        _SucceedSnackBar('This todo is updated'),
      );
    }

    final _handleSubmit = useCallback(() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState?.save();
      try {
        if (_todo == null) {
          await _addTodo();
        } else {
          await _updateTodo();
        }
      } on Exception catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          _FailedSnackBar(e.toString()),
        );
        return;
      } catch (e) {
        print(e.toString());
        return;
      }

      Navigator.of(context).pop(true);
    }, [_formKey]);

    return Scaffold(
        key: Key('todo-form'),
        appBar: AppBar(
          title:
              _todo == null ? const Text('Add todo') : const Text('Edit todo'),
        ),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: <Widget>[
                  TextFormField(
                    key: const Key('todo-form-field-title'),
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
                    maxLines: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? 10
                        : 5,
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

SnackBar _SucceedSnackBar(String message) {
  return SnackBar(
      backgroundColor: Colors.green,
      content: Row(children: [
        const Icon(Icons.check_circle, color: Colors.white),
        const SizedBox(width: 10),
        Text(message)
      ]));
}

SnackBar _FailedSnackBar(String message) {
  return SnackBar(
      backgroundColor: Colors.red,
      content: Row(children: [
        const Icon(Icons.error, color: Colors.white),
        const SizedBox(width: 10),
        Text(message)
      ]));
}
