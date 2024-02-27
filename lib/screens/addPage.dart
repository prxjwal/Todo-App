// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControllerP extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController desContoller = TextEditingController();

  String get text1 => titleController.text;
  String get text2 => desContoller.text;
}

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddToPageState();
}

class _AddToPageState extends State<AddPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerP>(
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
            onPressed: () {
              submitData();
            },
            child: const Icon(Icons.save),
          ),
        );
      },
    );
  }
}

void submitData() async {
  final controller = Get.find<ControllerP>();
  final Title = controller.titleController.text;
  final Desc = controller.desContoller.text;

  final body = {"title": Title, "description": Desc, "iscompleted": false};

  const url = "https://api.nstack.in/v1/todos";
  final uri = Uri.parse(url);
  final response = await http.put(uri, body: jsonEncode(body), headers: {
    "Content-Type": "application/json",
  });

  void showSnackBar(String message) {
    Get.snackbar('Message', message, snackPosition: SnackPosition.TOP);
  }

  if (response.statusCode == 200) {
    controller.titleController.text = '';
    controller.desContoller.text = '';
    controller.update([1]); // Update the flag value to 1
    showSnackBar('Todo added successfully');
  } else {
    controller.update([0]); // Update the flag value to 0
    showSnackBar('Failed to add todo');
  }
}
