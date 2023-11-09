import 'package:flutter/material.dart';
import 'package:todo_app/widgets/todo_widget.dart';

import '../core/entity/todo_entity.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<TodoEntity> listOfTasks = [
    TodoEntity(
        title: "test", date: DateTime.now(), description: "testtesttest"),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
      ),
      body:  Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: listOfTasks.length,
                itemBuilder: (context, index) {
                  final element = listOfTasks[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: TodoWidget(entity: element),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {},
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
