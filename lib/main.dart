import 'package:flutter/material.dart';
import 'package:webspark_test_task/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: PathFindingApp()));
}

class PathFindingApp extends StatelessWidget {
  const PathFindingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      theme: ThemeData(useMaterial3: false),
    );
  }
}
