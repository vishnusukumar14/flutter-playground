import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const HomePage2(),
    );
  }
}

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
              crossAxisAlignment: CrossAxisAlignment.center,
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

class HomePage2 extends ConsumerStatefulWidget {
  const HomePage2({super.key});

  @override
  ConsumerState createState() => _HomePage2State();
}

Future<String> getString() async {
  await Future.delayed(Duration(seconds: 5));
  return "ok baby";
}

class _HomePage2State extends ConsumerState<HomePage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: getString(),
          builder: (context, re) {
            if (re.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (re.hasData) {
              return Text(re.data ?? "");
            } else {
              return Text('No data');
            }
          },
        ),
      ),
    );
  }
}
