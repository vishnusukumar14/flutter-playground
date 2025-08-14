import 'package:flutter/material.dart';

class StreamBuilderHome extends StatefulWidget {
  const StreamBuilderHome({super.key});

  @override
  State createState() => _StreamBuilderHomeState();
}

Stream<String> getString() async* {
  while (true) {
    await Future.delayed(Duration(milliseconds: 1));
    yield "Stream Builder Home${DateTime.now().microsecondsSinceEpoch}";
  }
}

class _StreamBuilderHomeState extends State<StreamBuilderHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: StreamBuilder(
            stream: getString(),
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
