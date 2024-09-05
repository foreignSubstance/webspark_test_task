import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webspark_test_task/providers/playfield_provider.dart';

class PreviewScreen extends ConsumerWidget {
  final String path;
  const PreviewScreen({
    super.key,
    required this.path,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final solution = ref.watch(playfieldProvider);
    final calculatedPlayfield = solution[path];
    int elemetCount = sqrt(calculatedPlayfield!.length).toInt();
    return Scaffold(
      appBar: AppBar(title: const Text('Preview screen')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: elemetCount,
                childAspectRatio: 1,
              ),
              children: calculatedPlayfield,
            ),
          ),
          Text(path),
        ],
      ),
    );
  }
}
