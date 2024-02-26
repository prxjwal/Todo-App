// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class ControllerT extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController desContoller = TextEditingController();

  String get text1 => titleController.text;
  String get text2 => desContoller.text;
}

class AddToPage extends StatelessWidget {
  const AddToPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerT>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Add Todo')),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: controller.titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: controller.desContoller,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: submitData,
            child: const Icon(Icons.save),
          ),
        );
      },
    );
  }
}

void submitData() {
  final controller = Get.find<ControllerT>();
  final Title = controller.titleController.text;
  final Desc = controller.desContoller.text;

  final body = {
    "title": Title,
    "description": Desc,
    "iscompleted": false
  }
}
