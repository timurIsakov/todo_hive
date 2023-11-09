import 'package:flutter/material.dart';
import 'package:todo_app/core/entity/todo_entity.dart';

class TodoWidget extends StatelessWidget {
  final TodoEntity entity;
  const TodoWidget({Key? key, required this.entity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 25,
          offset: Offset(0, 10),
        )
      ]),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(entity.title), Text(entity.date.toString())],
            ),
            Text(entity.description),
          ],
        ),
      ),
    );
  }
}
