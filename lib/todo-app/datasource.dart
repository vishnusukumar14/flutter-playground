import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:test_palyground/todo-app/todo.dart';

import '../person.dart';

class TodoRemoteSource {
  List<Todo> parseTodos(String responseBody) {
    final List<dynamic> jsonList = jsonDecode(responseBody);
    return jsonList.map((todo) => Todo.fromMap(todo)).toList();
  }

  Future<void> refresh() async {
    fetchTodos();
  }

  Future<List<Todo>> fetchTodos() async {
    final Uri url = Uri.https("jsonplaceholder.typicode.com", "todos");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return compute(parseTodos, response.body);
    }
    return [];
  }
}
