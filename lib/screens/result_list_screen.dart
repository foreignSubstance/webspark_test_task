import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webspark_test_task/providers/fetch_data_provider.dart';
import 'package:webspark_test_task/providers/path_provider.dart';
import 'package:webspark_test_task/screens/preview_screen.dart';

class ResultListScreen extends ConsumerWidget {
  const ResultListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataList = ref.watch(fetchedDataProvider);
    final pathDetails = ref.watch(pathListProvider);
    return dataList.when(
      data: (value) => Scaffold(
        appBar: AppBar(
          title: const Text('Result list screen'),
        ),
        body: ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, count) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PreviewScreen(
                        path: pathDetails[count],
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        pathDetails[count],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider()
                  ],
                ),
              );
            }),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text(error.toString())),
      ),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
