import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_flutter/screens/todo_list.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.dark(),
      home: const TodoListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
