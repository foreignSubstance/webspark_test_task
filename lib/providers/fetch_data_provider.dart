import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:webspark_test_task/model/fetched_data.dart';

final fetchedDataProvider = FutureProvider((ref) async {
  var urlToProcess = ref.watch(rawUrlProvider);
  var url = Uri.parse(urlToProcess);
  var response = await http.get(url);
  Map<String, dynamic> data = json.decode(response.body);
  List<FetchedData> fields = [];
  for (final item in data.entries) {
    if (item.key == 'data') {
      for (final elem in item.value) {
        fields.add(
          FetchedData(
            id: elem['id'] as String,
            field: List<String>.from(elem['field'] as List),
            startPos: [elem['start']['x'], elem['start']['y']],
            endPos: [elem['end']['x'], elem['end']['y']],
          ),
        );
      }
    }
  }
  return fields;
});

final rawUrlProvider = StateProvider((ref) {
  return '';
});
