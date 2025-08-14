import 'package:equatable/equatable.dart';

import '../model/todo.dart';

class TodoState extends Equatable {
  final List<Todos> todos;

  const TodoState({this.todos = const []});

  TodoState copyWith({List<Todos>? todos}) {
    return TodoState(todos: todos ?? this.todos);
  }

  @override
  List<Object?> get props => [todos];
}
