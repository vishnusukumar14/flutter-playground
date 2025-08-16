import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'main.dart';

final class CountNotifier extends StateNotifier<int> {
  CountNotifier() : super(0);

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }
}

final counterStateNotifierProvider = StateNotifierProvider<CountNotifier, int>(
  (ref) => CountNotifier(),
);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final count = ref.watch(counterStateNotifierProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(counterStateNotifierProvider.notifier).increment();
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          child: Center(
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(count.toString(), style: TextStyle(fontSize: 56)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
