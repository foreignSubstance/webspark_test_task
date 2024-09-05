import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webspark_test_task/algorithm/shortest_path_finding.dart';
import 'package:webspark_test_task/providers/fetch_data_provider.dart';
import 'package:webspark_test_task/widgets/path_cell.dart';

final playfieldProvider = StateProvider<Map<String, List<PathCell>>>((ref) {
  Map<String, List<PathCell>> result = {};
  final dataList = ref.watch(fetchedDataProvider).value;
  for (final task in dataList!) {
    final List<String> matr = task.field;
    final List<int> startPos = task.startPos;
    final List<int> endPos = task.endPos;
    final List<List<int>> path = getPath(matr, startPos, endPos);
    final List<List<PathCell>> field =
        modifyPlayfield(matr, startPos, endPos, path);
    final List<PathCell> cellsList = field.expand((list) => list).toList();
    final String pathDescription = pathDetails(path);
    result[pathDescription] = cellsList;
  }
  return result;
});

List<List<PathCell>> modifyPlayfield(
  List<String> matr,
  List<int> startPos,
  List<int> endPos,
  List<List<int>> path,
) {
  List<List<PathCell>> cellsList = [];

  for (int i = 0; i < matr.length; i++) {
    cellsList.add([]);
    for (int j = 0; j < matr.length; j++) {
      CellType type;
      if (matr[i][j] == 'X') {
        type = CellType.blocked;
      } else if (startPos[0] == i && startPos[1] == j) {
        type = CellType.begin;
      } else if (endPos[0] == i && endPos[1] == j) {
        type = CellType.end;
      } else {
        type = CellType.regular;
      }
      cellsList[i].add(PathCell(coordinates: [j, i], type: type));
    }
  }

  for (int i = 1; i < path.length - 1; i++) {
    int row = path[i][0];
    int col = path[i][1];
    cellsList[row][col] = PathCell(
      coordinates: [col, row],
      type: CellType.transit,
    );
  }
  return cellsList;
}
