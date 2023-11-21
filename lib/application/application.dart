import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/list_provider.dart';
import 'package:todo_app/provider/theme_provider.dart';

import '../screens/home_screen.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ListProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, data, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                colorScheme: data.isDark
                    ? const ColorScheme.dark()
                    : const ColorScheme.light()),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
