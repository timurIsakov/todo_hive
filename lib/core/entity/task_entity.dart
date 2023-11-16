import 'package:hive_flutter/adapters.dart';

part 'task_entity.g.dart';

@HiveType(typeId: 2)
enum TaskStatus {
  @HiveField(1)
  todo,
  @HiveField(2)
  process,
  @HiveField(3)
  done
}

@HiveType(typeId: 1)
class TaskEntity {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final TaskStatus status;

  TaskEntity(
      {required this.id,
      required this.status,
      required this.title,
      required this.date,
      required this.description});

  factory TaskEntity.fromJson(Map<String, dynamic> json) {
    return TaskEntity(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      status: TaskStatus.values[json['isDone']],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['date'] = date.toIso8601String();
    data['description'] = description;
    data['isDone'] = status.index;

    return data;
  }

  @override
  String toString() {
    return "id: $id, title: $title, description: $description";
  }
}
