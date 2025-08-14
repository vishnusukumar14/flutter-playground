import 'package:flutter/material.dart';

class FutureBuilderHome extends StatefulWidget {
  const FutureBuilderHome({super.key});

  @override
  State createState() => _FutureBuilderHomeState();
}

Future<String> getString() async {
  await Future.delayed(Duration(seconds: 3));
  return "Future Builder Home${DateTime.now().microsecondsSinceEpoch}";
}

class _FutureBuilderHomeState extends State<FutureBuilderHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: getString(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData) {
                return Text("${snapshot.data}");
              } else {
                return Text("${snapshot.error}");
              }
            },
          ),
        ),
      ),
    );
  }
}
