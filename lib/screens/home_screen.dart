import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:todo_app/core/local_api/task_local_api.dart';
import 'package:todo_app/core/utils/dialogs_helper.dart';
import 'package:todo_app/screens/add_task_screen.dart';
import 'package:todo_app/widgets/task_card_widget.dart';

import '../core/entity/task_entity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  List<TaskEntity> listOfTasks = [];

  @override
  void initState() {
    initialization();
    super.initState();
  }

  initialization() async {
    final listData = await TaskLocalApi.getAll();
    listOfTasks = listData;

    setState(() {});
  }

  _onDeleteTask(TaskEntity entity) async {
    final result = await DialogsHelper.deleteTask(context);
    if (result!) {
      await TaskLocalApi.deleteTask(entity);
      _onRefreshData();
      setState(() {});
    }
  }

  _onRefreshData() async {
    listOfTasks.clear();
    listOfTasks = await TaskLocalApi.getAll();
    setState(() {});
  }

  _onSearch(String text) async {
    if (_textEditingController.text.isEmpty) {
      listOfTasks = await TaskLocalApi.getAll();
      setState(() {});
      return;
    }
    List<TaskEntity> filterList = [];
    for (var element in listOfTasks) {
      if (element.title == _textEditingController.text) {
        filterList.add(element);
      }
    }
    listOfTasks.clear();
    listOfTasks = filterList;
    setState(() {});
  }

  _onCreateTask(String title, String description) async {
    final epochStart = DateTime.now().millisecondsSinceEpoch;
    final TaskEntity entity = TaskEntity(
        id: epochStart.toString(),
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

  _onDeleteAll() async {
    final isDeleted = await TaskLocalApi.deleteAll();
    if (isDeleted) {
      _onRefreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tasks"),
          actions: [
            IconButton(
                onPressed: () {
                  print("Pressed delete all elements");
                  _onDeleteAll();
                },
                icon: const Icon(Icons.delete_forever)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              TextField(
                  controller: _textEditingController,
                  onChanged: (String text) async {
                    if (_textEditingController.text.isEmpty) {
                      _onRefreshData();
                      return;
                    }
                  },
                  onSubmitted: (String text) {
                    _onSearch(text);
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        _textEditingController.clear();
                        _onRefreshData();
                      },
                      icon: const Icon(Icons.close),
                    ),
                    labelText: "Search",
                  )),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: listOfTasks.length,
                  itemBuilder: (context, index) {
                    final entity = listOfTasks[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: GestureDetector(
                          onTap: ()  {
                            print("Call function onDeleteTask");
                            _onDeleteTask(entity);
                          },
                          child: TaskCardWidget(entity: entity)),
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
      ),
    );
  }
}
