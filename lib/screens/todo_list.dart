import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:todo_flutter/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  void initState() {
    fetchTodo();
    super.initState();
  }

  List items = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerT>(
      init: ControllerT(),
      builder: (controller) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: fetchTodo,
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  return ListTile(
                    trailing: PopupMenuButton(onSelected: (value) {
                      if (value == "edit") {
                        //
                      } else if (value == "delete") {
                        deleteById(item['_id'] as String);
                      }
                    }, itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          child: Text('Edit'),
                          value: 'edit',
                        ),
                        const PopupMenuItem(
                          child: Text('Delete'),
                          value: 'delete',
                        )
                      ];
                    }),
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(item["title"]),
                    subtitle: Text(item["description"]),
                  );
                }),
          ),
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

  Future<void> deleteById(String id) async {
    var url = 'https://api.nstack.in/v1/todos/$id';
    var uri = Uri.parse(url);

    final res = await http.delete(uri);
    if (res.statusCode == 200) {
      final filtered = items.where((element) => element[id] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showSnackBar("Not deleted");
    }
  }

  Future<void> fetchTodo() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=20';
    final uri = Uri.parse(url);
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final jason = jsonDecode(res.body) as Map;
      final result = jason['items'] as List;
      setState(() {
        items = result;
      });
    }
  }

  Future<void> naviagteToEdit() async {
    Get.to(const AddToPage());
  }

  void showSnackBar(String message) {
    Get.snackbar('Message', message, snackPosition: SnackPosition.TOP);
  }

  void navigate() {
    Get.to(const AddToPage());
  }
}
