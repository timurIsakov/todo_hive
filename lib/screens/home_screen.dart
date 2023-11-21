import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/utils/assets.dart';
import 'package:todo_app/provider/list_provider.dart';
import 'package:todo_app/provider/theme_provider.dart';
import 'package:todo_app/screens/add_task_screen.dart';
import 'package:todo_app/widgets/task_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    initialization();
    super.initState();
  }

  initialization() {
    context.read<ListProvider>().initialization();
    context.read<ThemeProvider>().getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.read<ThemeProvider>().changeTheme();
            },
            icon: context.watch<ThemeProvider>().isDark
                ? const Icon(Icons.light_mode)
                : const Icon(Icons.dark_mode),
          ),
          title: const Text("Tasks"),
          actions: [
            IconButton(
                onPressed: () {
                  print("Pressed delete all elements");
                  context.read<ListProvider>().onDeleteAll(context);
                  // _onDeleteAll();
                },
                icon: const Icon(Icons.delete_forever)),
          ],
        ),
        body: Consumer<ListProvider>(
          builder: (context, data, child) {
            return Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                children: [
                  TextField(
                      controller: _textEditingController,
                      onChanged: (String text) async {
                        if (_textEditingController.text.isEmpty) {
                          context.read<ListProvider>().onRefreshData();
                          return;
                        }
                      },
                      onSubmitted: (String text) {
                        print("Call function 'onSearch'");
                        context.read<ListProvider>().onSearch(text);
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            _textEditingController.clear();
                            context.read<ListProvider>().onRefreshData();
                          },
                          icon: const Icon(Icons.close),
                        ),
                        labelText: "Search",
                      )),
                  Row(
                    children: [
                      Container(
                        color: data.isFilter ? Colors.green : null,
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
                        value: data.dropdownValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 20,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? value) {
                          context.read<ListProvider>().isFilterList(value!);
                          context
                              .read<ListProvider>()
                              .onFilterTasks(data.list.indexOf(value));
                        },
                        items: data.list
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  data.listOfTasks.isEmpty
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
                          child: ListView.builder(
                            itemCount: data.listOfTasks.length,
                            itemBuilder: (context, index) {
                              final entity = data.listOfTasks[index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: GestureDetector(
                                    onTap: () {
                                      print("Call function onDeleteTask");
                                      context
                                          .read<ListProvider>()
                                          .onDeleteTask(entity, context);
                                    },
                                    child: TaskCardWidget(entity: entity)),
                              );
                            },
                          ),
                        )
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTaskScreen(),
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
