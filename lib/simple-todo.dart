import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:get_it/get_it.dart';

import 'model/todo.dart';

part 'simple-todo.g.dart';

final todos = List.generate(
  4,
  (index) => Todos.create(
    title: 'Todo ${index + 1}',
    descp: 'Description ${index + 1}',
  ),
);

@riverpod
class NewTodos extends _$NewTodos {
  @override
  List<Todos> build() {
    return todos;
  }

  void addTodo(Todos todo) {
    state = [...state, todo];
  }

  void deleteTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }

  void markDone(String id) {
    state = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(isEnabled: !todo.isEnabled);
      }
      return todo;
    }).toList();
  }
}

class TodoSimple extends ConsumerStatefulWidget {
  const TodoSimple({super.key});

  @override
  ConsumerState<TodoSimple> createState() => _TodoSimpleState();
}

class _TodoSimpleState extends ConsumerState<TodoSimple> {
  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(newTodosProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_circle),
        onPressed: () {
          ref
              .read(newTodosProvider.notifier)
              .addTodo(
                Todos.create(title: "${DateTime.now().microsecondsSinceEpoch}"),
              );
        },
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(todos[index].title),
            subtitle: Text("${todos[index].descp}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: todos[index].isEnabled,
                  onChanged: (value) => ref
                      .read(newTodosProvider.notifier)
                      .markDone(todos[index].id),
                ),
                GestureDetector(
                  onTap: () {
                    ref
                        .read(newTodosProvider.notifier)
                        .deleteTodo(todos[index].id);
                  },
                  child: Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final getIt = GetIt.instance;

class ApiService {
  void fetch() => print("Fetching data");
}

void setup() {
  getIt.registerSingleton(ApiService());
}

void main() {
  setup();
  getIt<ApiService>().fetch();
}
