import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:test_palyground/todo-app/todo.dart';

// Parsing function must be a top-level or static function
List<Todo> _parseTodos(List<dynamic> jsonList) {
  return jsonList.map((todo) => Todo.fromMap(todo)).toList();
}

class TodoRemoteSourceDio {
  final Dio _dio;

  TodoRemoteSourceDio(this._dio);

  Future<void> refresh() async {
    await fetchTodos();
  }

  Future<List<Todo>> fetchTodos() async {
    try {
      final response = await _dio.get(
        "https://jsonplaceholder.typicode.com/todos/",
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        // Offload parsing to an isolate
        return compute(_parseTodos, jsonList);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching todos: $e");
      }
    }
    return [];
  }
}
