import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class Todo extends Equatable {
  final int userId;
  final int id;
  final String title;
  final String? subtitle;
  final bool isCompleted;

  const Todo({
    required this.userId,
    required this.id,
    required this.title,
    this.subtitle,
    this.isCompleted = false,
  });

  factory Todo.create({
    required int userId,
    required String title,
    String? descp = "todo-subtitle",
  }) => Todo(
    userId: userId,
    title: title,
    subtitle: descp,
    id: DateTime.now().microsecondsSinceEpoch.toInt(),
  );

  Todo copyWith({String? title, String? descp, bool? isCompleted}) => Todo(
    userId: userId,
    id: id,
    title: title ?? this.title,
    subtitle: descp ?? subtitle,
    isCompleted: isCompleted ?? this.isCompleted,
  );

  @override
  List<Object?> get props => [userId, id, title, isCompleted];

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'descp': subtitle,
      'completed': isCompleted,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      userId: map['userId'] as int,
      id: map['id'] as int,
      title: map['title'] as String,
      subtitle: map['descp'] ?? "todo-subtitle",
      isCompleted: map['completed'] as bool,
    );
  }
}
