import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'application/application.dart';
import 'core/entity/task_entity.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskEntityAdapter());
  Hive.registerAdapter(TaskStatusAdapter());
  runApp(const Application());
}
