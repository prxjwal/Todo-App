// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

int flag = 0;

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
          floatingActionButton: const FloatingActionButton(
            onPressed: submitData,
            child: Icon(Icons.save),
          ),
        );
      },
    );
  }
}

void submitData() async {
  final controller = Get.find<ControllerT>();
  final Title = controller.titleController.text;
  final Desc = controller.desContoller.text;

  final body = {"title": Title, "description": Desc, "iscompleted": false};

  const url = "https://api.nstack.in/v1/todos";
  final uri = Uri.parse(url);
  final response = await http.post(uri, body: jsonEncode(body), headers: {
    "Content-Type": "application/json",
  });

  void showSnackBar(String message) {
    Get.snackbar('Message', message, snackPosition: SnackPosition.TOP);
  }

  if (response.statusCode == 201) {
    final controller = Get.find<ControllerT>();
    controller.titleController.text = '';
    controller.desContoller.text = '';
    Get.find<ControllerT>().update([1]); // Update the flag value to 1
    showSnackBar('Todo added successfully');
  } else {
    Get.find<ControllerT>().update([0]); // Update the flag value to 0
    showSnackBar('Failed to add todo');
  }
}
