import 'package:equatable/equatable.dart';
import 'package:test_palyground/model/todo.dart';

abstract class TodoEvent extends Equatable {}

class AddTodo extends TodoEvent {
  final Todos todo;

  AddTodo(this.todo);

  @override
  List<Object?> get props => [todo];
}

class ToggleTodo extends TodoEvent {
  final String id;

  ToggleTodo(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteTodo extends TodoEvent {
  final String id;

  DeleteTodo(this.id);

  @override
  List<Object?> get props => [id];
}
