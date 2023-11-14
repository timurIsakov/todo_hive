import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../widgets/date_time_picker_widget.dart';

class AddTaskScreen extends StatefulWidget {
  final Function(String title, String description, DateTime dateTime) onCreate;
  const AddTaskScreen({Key? key, required this.onCreate}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();

  DateTime? selectedDateTime = DateTime.now();

  _getDateTime(DateTime data) {
    final result = data;
    setState(() {
      selectedDateTime = result;
    });
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
              DateTimePickerWidget(function: _getDateTime),
              const SizedBox(height: 20),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("Call function 'onSave'");
            widget.onCreate.call(controllerTitle.text,
                controllerDescription.text, selectedDateTime ?? DateTime.now());
            Navigator.pop(
              context,
            );
          },
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.save_alt),
        ),
      ),
    );
  }
}
