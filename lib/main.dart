import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_palyground/simple-todo-sestate.dart';
import 'package:test_palyground/todo-app/todo-ui.dart';

import 'bloc/bloc_todo.dart';

//
// void main() {
//   runApp(ProviderScope(child: const MyApp()));
// }

void main() {
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => TodoBloc())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: SimpleTodoSetstate(),
    );
  }
}
