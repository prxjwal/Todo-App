import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:todo_flutter/screens/add_page.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerT>(
      init: ControllerT(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Todo List')),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Get.to(const AddToPage());
            },
            label: const Text("Add Todo"),
          ),
        );
      },
    );
  }
}

void navigate() {
  Get.to(const AddToPage());
}
