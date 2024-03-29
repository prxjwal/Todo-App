// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

int flag = 0;
bool isEdit = false;

class ControllerT extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController desContoller = TextEditingController();

  String get text1 => titleController.text;
  String get text2 => desContoller.text;
}

class AddToPage extends StatefulWidget {
  final Map? todo;

  const AddToPage({super.key, this.todo});

  @override
  State<AddToPage> createState() => _AddToPageState();
}

class _AddToPageState extends State<AddToPage> {
  @override
  void initState() {
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
    }
    final title = todo?['title'];
    final desc = todo?['description'];
    final controller = Get.find<ControllerT>();
    controller.titleController.text = title;
    controller.desContoller.text = desc;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerT>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: Text(isEdit ? "Edit todo" : 'Add Todo')),
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
              if (isEdit) {
                final todo = widget.todo;
                updateData(todo!);
              } else {
                submitData();
              }
            },
            child: const Icon(Icons.save),
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

void updateData(Map todo) async {
  final controller = Get.find<ControllerT>();
  final Title = controller.titleController.text;
  final Desc = controller.desContoller.text;
  final id = todo['_id'];
  final body = {"title": Title, "description": Desc, "iscompleted": false};

  var url = "https://api.nstack.in/v1/todos/$id";
  final uri = Uri.parse(url);
  final response = await http.put(uri, body: jsonEncode(body), headers: {
    "Content-Type": "application/json",
  });

  void showSnackBar(String message) {
    Get.snackbar('Message', message, snackPosition: SnackPosition.TOP);
  }

  if (response.statusCode == 200) {
    final controller = Get.find<ControllerT>();
    controller.titleController.text = '';
    controller.desContoller.text = '';
    Get.find<ControllerT>().update([1]); // Update the flag value to 1
    showSnackBar('Todo updated successfully');
  } else {
    Get.find<ControllerT>().update([0]); // Update the flag value to 0
    showSnackBar('Failed to update todo');
  }
}
