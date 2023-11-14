import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class AddTaskScreen extends StatefulWidget {
  final Function(String title, String description) onCreate;
  const AddTaskScreen({Key? key, required this.onCreate}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add task"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              TextField(
                  controller: controllerTitle,
                  decoration: const InputDecoration(
                    labelText: "Title",
                  )),
              TextField(
                  controller: controllerDescription,
                  decoration: const InputDecoration(
                    labelText: "Description",
                  )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print("Call function 'onSave'");
                  widget.onCreate
                      .call(controllerTitle.text, controllerDescription.text);
                  Navigator.pop(
                    context,
                  );
                },
                child: const Text("SAVE"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
