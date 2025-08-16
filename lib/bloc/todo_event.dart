import 'package:equatable/equatable.dart';

import '../todo-app/todo.dart';

abstract class TodoEvent extends Equatable {}

class AddTodo extends TodoEvent {
  final Todo todo;

  AddTodo(this.todo);

  @override
  List<Object?> get props => [todo];
}

class ToggleTodo extends TodoEvent {
  final int id;

  ToggleTodo(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteTodo extends TodoEvent {
  final int id;

  DeleteTodo(this.id);

  @override
  List<Object?> get props => [id];
}
