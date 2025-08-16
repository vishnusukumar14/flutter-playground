import 'package:flutter/material.dart';
import 'package:test_palyground/todo-app/todo.dart';

class SimpleTodoSetstate extends StatefulWidget {
  const SimpleTodoSetstate({super.key});

  @override
  State<SimpleTodoSetstate> createState() => _SimpleTodoSetstateState();
}

class _SimpleTodoSetstateState extends State<SimpleTodoSetstate> {
  late List<Todo> todos;

  @override
  void initState() {
    super.initState();
    todos = List.generate(
      6,
      (i) => Todo.create(userId: 1, title: "title-sub-$i"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OutlinedButton(
              onPressed: () {
                showTimePicker(
                  initialEntryMode: TimePickerEntryMode.inputOnly,
                  switchToTimerEntryModeIcon: Icon(Icons.ac_unit_outlined),
                  switchToInputEntryModeIcon: Icon(Icons.add_circle),
                  minuteLabelText: "Choose the time",

                  context: context,
                  initialTime: TimeOfDay.now(),
                );
              },
              child: Text("data"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(todos[index].title),
                    subtitle: Text(todos[index].subtitle ?? ""),
                    value: todos[index].isCompleted,
                    onChanged: (bool? value) {
                      setState(() {
                        todos[index] = todos[index].copyWith(
                          isCompleted: value,
                        );
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
