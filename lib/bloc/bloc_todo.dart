import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/todo.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class PlayAvatar {
  final String name;
  static final Map<String, PlayAvatar> _cache = {};

  factory PlayAvatar.named(String name) {
    return _cache.putIfAbsent(name, () => PlayAvatar._new(name));
  }

  PlayAvatar._new(this.name);
}

void cs() {
  final name1 = PlayAvatar.named("name");
  final name2 = PlayAvatar.named("name2");

  if (kDebugMode) {
    print(identical(name2, name1));
  }
}

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoState()) {
    on<AddTodo>((event, emit) {
      final List<Todos> updated = List.from(state.todos)..add(event.todo);
      emit(state.copyWith(todos: updated));
    });

    on<DeleteTodo>((event, emit) {
      final updated = state.todos.where((todo) => todo.id == event.id).toList();
      emit(state.copyWith(todos: updated));
    });

    on<ToggleTodo>((event, emit) {
      final updated = state.todos.map((todo) {
        return todo.id == event.id
            ? todo.copyWith(isEnabled: !todo.isEnabled)
            : todo;
      }).toList();
      emit(state.copyWith(todos: updated));
    });
  }
}
vo
class HomeSte extends StatelessWidget {
  const HomeSte({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<TodoBloc>().add(
            AddTodo(
              Todos.create(
                title: "New todo - ${Random.secure().nextInt(1545)}",
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: DataTable(
          columns: [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Age')),
          ],
          rows: [
            DataRow(cells: [DataCell(Text('John')), DataCell(Text('5'))]),
          ],
        ),
      ),
    );
  }
}
