import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webspark_test_task/algorithm/shortest_path_finding.dart';
import 'package:webspark_test_task/providers/fetch_data_provider.dart';

final pathListProvider = Provider<List<String>>((ref) {
  final dataList = ref.watch(fetchedDataProvider).value;
  final List<String> pathList = [];
  List<String> matr;
  List<int> startPos;
  List<int> endPos;
  List<List<int>> path;
  String pathDescription;

  for (final data in dataList!) {
    matr = data.field;
    startPos = data.startPos;
    endPos = data.endPos;
    path = getPath(matr, startPos, endPos);
    pathDescription = pathDetails(path);
    pathList.add(pathDescription);
  }
  return pathList;
});
