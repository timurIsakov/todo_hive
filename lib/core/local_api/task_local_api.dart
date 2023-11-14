import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/core/entity/task_entity.dart';
import 'package:todo_app/core/utils/hive_box_constants.dart';

class TaskLocalApi {
  static Future<bool> save(TaskEntity entity) async {
    try {
      final box = await Hive.openBox(HiveBoxConstants.tasksBox);
      box.put(entity.id, entity.toJson());
      print("Entity save!");
      print("Box values ${box.values}");
      print("Box keys ${box.keys}");
      return Future.value(true);
    } catch (error) {
      return Future.value(false);
    }
  }

  static Future<bool> deleteTask(TaskEntity entity) async {
    try {
      final box = await Hive.openBox(HiveBoxConstants.tasksBox);
      print("Box values before delete ${box.values}");
      print("Box keys before delete ${box.keys}");

      box.delete(entity.id);
      print("The entity was deleted using the passed key");
      print("Box values after delete ${box.values}");
      print("Box keys after delete ${box.keys}");
      return Future.value(true);
    } catch (error) {
      return Future.value(false);
    }
  }

  static Future<List<TaskEntity>> getAll() async {
    try {
      print("Call function 'getAll'");
      final box = await Hive.openBox(HiveBoxConstants.tasksBox);
      List<TaskEntity> listOfTasks = [];
      for (var json in box.values) {
        listOfTasks.add(TaskEntity.fromJson(Map.from(json)));
      }
      print("Box has values: ${box.length}");
      return listOfTasks;
    } catch (error) {
      return [];
    }
  }

  static Future<bool> deleteAll() async {
    try {
      final box = await Hive.openBox(HiveBoxConstants.tasksBox);
      await box.clear();
      print("Box deleted all elements");
      print("Box values ${box.values}");
      return Future.value(true);
    } catch (error) {
      return Future.value(false);
    }
  }

  static Future<List<TaskEntity>> search(String data) async {
    try {
      final box = await Hive.openBox(HiveBoxConstants.tasksBox);
      List<TaskEntity> filterList = [];
      for (var json in box.values) {
        filterList.add(TaskEntity.fromJson(Map.from(json)));
      }

      filterList.removeWhere((element) =>
          !element.title.contains(data) && !element.description.contains(data));

      print("Result ${filterList.toString()}");
      return filterList;
    } catch (error) {
      return [];
    }
  }

  static Future<List<TaskEntity>> getFilter(int index) async{
    List<TaskEntity> listTasks = await getAll();


    switch(index){
      case 0:
        listTasks.sort((a, b) => a.date.compareTo(b.date),);
        return listTasks;
        default:
          return [];
    }





  }
}
