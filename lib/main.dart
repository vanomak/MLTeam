import 'package:flutter/material.dart';
import 'package:ml_team/text-recognition.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: TextRecognition.route,
      routes: {
        // MyHomePage.route: (_) => const MyHomePage(),
        TextRecognition.route: (_) => const TextRecognition(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const route = "/";
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ML"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Распознавание"),
          onPressed: () {
            Navigator.of(context).pushNamed(TextRecognition.route);
          },
        ),
      ),
    );
  }
}
