import 'package:flutter/material.dart';
import 'package:todo_app/core/local_api/task_local_api.dart';
import 'package:todo_app/screens/add_task_screen.dart';
import 'package:todo_app/widgets/task_card_widget.dart';

import '../core/entity/task_entity.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<TaskEntity> listOfTasks = [];

  @override
  void initState() {
    initialization();
    super.initState();
  }

  initialization() async {
    final listData = await TaskLocalApi.getAll();
    listOfTasks = listData;


    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
      ),
      body: Padding(
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
                    child: TaskCardWidget(entity: element),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(
                onCreate: _onCreateTask,
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  _onCreateTask(String title, String description) async {
    final TaskEntity entity = TaskEntity(
        status: TaskStatus.todo,
        title: title,
        date: DateTime.now(),
        description: description);
    final result = await TaskLocalApi.save(entity);
    if (result) {
      listOfTasks.add(entity);
      setState(() {});
    }
  }
}
