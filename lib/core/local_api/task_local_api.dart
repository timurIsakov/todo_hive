import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/core/entity/task_entity.dart';
import 'package:todo_app/core/utils/hive_box_constants.dart';

class TaskLocalApi {
  static Future<bool> save(TaskEntity entity) async {
    try {
      final box = await Hive.openBox(HiveBoxConstants.tasksBox);
      box.add(entity.toJson());
      return Future.value(true);
    } catch (error) {
      return Future.value(false);
    }
  }

  static Future<List<TaskEntity>> getAll() async {
    try {
      final box = await Hive.openBox(HiveBoxConstants.tasksBox);
      List<TaskEntity> listOfTasks = [];
      for (var json in box.values) {
        listOfTasks.add(TaskEntity.fromJson(Map.from(json)));
      }
      return listOfTasks;
    } catch (error) {
      return [];
    }
  }
}
