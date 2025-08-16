import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_palyground/todo-app/dio_datasource.dart';
import 'package:test_palyground/todo-app/todo.dart';

class TodoFromInternet extends StatefulWidget {
  const TodoFromInternet({super.key});

  @override
  State<TodoFromInternet> createState() => _TodoFromInternetState();
}

class _TodoFromInternetState extends State<TodoFromInternet> {
  late Future<List<Todo>> todosFuture;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    setState(() => isLoading = true);
    todosFuture = TodoRemoteSourceDio(Dio()).fetchTodos();
    await todosFuture;
    setState(() => isLoading = false);
  }

  Future<void> _refresh() async {
    await _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: Column(
            children: [
              const LinearProgressIndicator(),
              Expanded(
                child: FutureBuilder<List<Todo>>(
                  future: todosFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        !isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      final todos = snapshot.data!;
                      if (todos.isEmpty) {
                        return const Center(child: Text("No todos found"));
                      }
                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final todo = todos[index];
                          return CheckboxListTile(
                            value: todo.isCompleted,
                            onChanged: (_) {},
                            title: Text(todo.title),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text("No todos found"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
