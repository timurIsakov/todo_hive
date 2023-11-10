import 'package:flutter/material.dart';
import 'package:todo_app/core/entity/task_entity.dart';

class TaskCardWidget extends StatelessWidget {
  final TaskEntity entity;

  const TaskCardWidget({Key? key, required this.entity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 25,
              offset: const Offset(0, 10),
            )
          ]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(entity.title), Text(entity.date.toString())],
          ),
          const Divider(),
          Text(entity.description),
        ],
      ),
    );
  }
}
