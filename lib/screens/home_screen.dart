import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/core/local_api/task_local_api.dart';
import 'package:todo_app/core/utils/assets.dart';
import 'package:todo_app/core/utils/dialogs_helper.dart';
import 'package:todo_app/core/utils/hive_box_constants.dart';
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
  bool isFilter = false;
  String dropdownValue = 'All';
  List<String> list = <String>[
    'New tasks',
    'Old tasks',
    'All',
  ];

  List<TaskEntity> listOfTasks = [];

  @override
  void initState() {
    initialization();
    super.initState();
  }

  _isFilterList(String value) {
    if (list.indexOf(value) == 0 || list.indexOf(value) == 1) {
      setState(() {
        isFilter = true;
      });
    } else {
      setState(() {
        isFilter = false;
      });
    }
  }

  initialization() async {
     listOfTasks = await TaskLocalApi.getAll();



  }

  _onDeleteTask(TaskEntity entity) async {
    final result = await DialogsHelper.deleteTask(context);
    if (result!) {
      await TaskLocalApi.deleteTask(entity);
      _onRefreshData();

    }
  }

  _onRefreshData() async {
    listOfTasks.clear();
     listOfTasks = await TaskLocalApi.getAll();


  }

  _onSearch(String text) async {
    listOfTasks.clear();
      listOfTasks = await TaskLocalApi.search(text);
      setState(() {

      });

  }

  _onCreateTask(String title, String description, DateTime dateTime) async {
    final epochStart = DateTime.now().millisecondsSinceEpoch;
    final TaskEntity entity = TaskEntity(
        id: epochStart.toString(),
        status: TaskStatus.todo,
        title: title,
        date: dateTime,
        description: description);
     await TaskLocalApi.save(entity);
     _onRefreshData();

  }

  _onDeleteAll() async {
    final result = await DialogsHelper.deleteAll(context);
    if (result!) {
      await TaskLocalApi.deleteAll();

      _onRefreshData();
    }
  }

  _onFilterTasks(int indexOfSelect) async {
    listOfTasks.clear();
    listOfTasks = await TaskLocalApi.getFilter(indexOfSelect);
    setState(() {});
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
                    print("Call function 'onSearch'");
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
              Row(
                children: [
                  Container(
                    color: isFilter ? Colors.green : null,
                    child: const Row(
                      children: [
                        Text("Filter", style: TextStyle(fontSize: 17)),
                        Icon(
                          Icons.filter_alt_outlined,
                          size: 17,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 20,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? value) {
                      _isFilterList(value!);
                      setState(() {
                        dropdownValue = value;
                      });
                      _onFilterTasks(list.indexOf(value));
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              listOfTasks.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: SizedBox(
                          height: 350,
                          width: 400,
                          child: Lottie.asset(
                            Assets.tAnimateEmpty,
                            fit: BoxFit.cover,
                          )),
                    )
                  : Expanded(
                      child: ValueListenableBuilder<Box<TaskEntity>>(
                        valueListenable: Hive.box<TaskEntity>(HiveBoxConstants.tasksBox).listenable(),
                        builder: (context,box,widget) {
                          //listOfTasks = box.values.toList();
                          return ListView.builder(
                            itemCount: listOfTasks.length,
                            itemBuilder: (context, index) {
                              final entity = listOfTasks[index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: GestureDetector(
                                    onTap: () {
                                      print("Call function onDeleteTask");
                                      _onDeleteTask(entity);
                                    },
                                    child: TaskCardWidget(entity: entity)),
                              );
                            },
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
