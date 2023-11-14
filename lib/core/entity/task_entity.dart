enum TaskStatus { todo, process, done }

class TaskEntity {
  final String id;
  final String title;
  final DateTime date;
  final String description;
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
}
