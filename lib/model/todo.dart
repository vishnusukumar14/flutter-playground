import 'package:equatable/equatable.dart';

class Todos extends Equatable {
  final String id;
  final String title;
  final String? descp;
  final bool isEnabled;

  const Todos({
    required this.id,
    required this.title,
    this.descp,
    this.isEnabled = false,
  });

  factory Todos.create({required String title, String? descp = "sdfsdfd"}) =>
      Todos(
        title: title,
        descp: descp,
        id: DateTime.now().microsecondsSinceEpoch.toString(),
      );

  Todos copyWith({String? title, String? descp, bool? isEnabled}) => Todos(
    id: id,
    title: title ?? this.title,
    descp: descp ?? this.descp,
    isEnabled: isEnabled ?? this.isEnabled,
  );

  @override
  List<Object?> get props => [id, title, isEnabled];
}
