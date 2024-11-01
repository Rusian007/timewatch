// lib/storage_helper.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'TodoItem.dart';
import 'dart:convert'; // Import this for JSON encoding/decoding
import 'notification_service.dart';

class StorageHelper {
  static Future<List<TodoItem>> loadTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todoListString = prefs.getString('todoList'); // Get the string

    if (todoListString != null) {
      // Decode the JSON string into a List
      List<dynamic> jsonList = json.decode(todoListString);
      return jsonList.map((item) => TodoItem.fromJson(item)).toList();
    }
    return []; // Return an empty list if no data found
  }

  static Future<void> saveTodoList(List<TodoItem> todoList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Convert the List<TodoItem> to a List<Map<String, dynamic>>
    String encodedData = json.encode(todoList.map((item) => item.toJson()).toList());
    await prefs.setString('todoList', encodedData); // Store the JSON string
  }
}