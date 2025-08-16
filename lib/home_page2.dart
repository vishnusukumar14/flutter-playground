import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<String> getString() async {
  await Future.delayed(Duration(seconds: 5));
  return "ok baby";
}

class HomePage2 extends ConsumerStatefulWidget {
  const HomePage2({super.key});

  @override
  ConsumerState createState() => _HomePage2State();
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
