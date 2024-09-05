class FetchedData {
  final String id;
  final List<String> field;
  final List<int> startPos;
  final List<int> endPos;

  FetchedData(
      {required this.id,
      required this.field,
      required this.startPos,
      required this.endPos});
}
