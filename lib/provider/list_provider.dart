import 'package:flutter/cupertino.dart';
import '../core/entity/task_entity.dart';
import '../core/local_api/task_local_api.dart';
import '../core/utils/dialogs_helper.dart';

class ListProvider extends ChangeNotifier {
  List<TaskEntity> listOfTasks = [];
  bool isFilter = false;
  String dropdownValue = 'All';
  List<String> list = <String>[
    'New tasks',
    'Old tasks',
    'All',
  ];

  onDeleteAll(BuildContext context) async {
    final result = await DialogsHelper.deleteAll(context);
    if (result!) {
      await TaskLocalApi.deleteAll();
      onRefreshData();
    }
  }

  onRefreshData() async {
    listOfTasks.clear();
    listOfTasks = await TaskLocalApi.getAll();
    notifyListeners();
  }

  initialization() async {
    listOfTasks = await TaskLocalApi.getAll();
    notifyListeners();
  }

  onCreateTask(String title, String description, DateTime dateTime) async {
    final epochStart = DateTime.now().millisecondsSinceEpoch;
    final TaskEntity entity = TaskEntity(
        id: epochStart.toString(),
        status: TaskStatus.todo,
        title: title,
        date: dateTime,
        description: description);
    await TaskLocalApi.save(entity);
    onRefreshData();
  }

  onDeleteTask(TaskEntity entity, BuildContext context) async {
    final result = await DialogsHelper.deleteTask(context);
    if (result!) {
      await TaskLocalApi.deleteTask(entity);
      onRefreshData();
    }
  }

  onFilterTasks(int indexOfSelect) async {
    listOfTasks.clear();
    listOfTasks = await TaskLocalApi.getFilter(indexOfSelect);
    notifyListeners();
  }

  onSearch(String text) async {
    listOfTasks.clear();
    listOfTasks = await TaskLocalApi.search(text);
    notifyListeners();
  }

  isFilterList(String value) {
    dropdownValue = value;
    if (list.indexOf(value) == 0 || list.indexOf(value) == 1) {
      isFilter = true;
    } else {
      isFilter = false;
    }
    notifyListeners();
  }
}
