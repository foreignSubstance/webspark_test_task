import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webspark_test_task/providers/fetch_data_provider.dart';
import 'package:webspark_test_task/providers/path_provider.dart';
import 'package:webspark_test_task/screens/result_list_screen.dart';
import 'package:webspark_test_task/widgets/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProcessScreen extends ConsumerStatefulWidget {
  const ProcessScreen({super.key});

  @override
  ConsumerState<ProcessScreen> createState() => _ProcessScreenState();
}

class _ProcessScreenState extends ConsumerState<ProcessScreen> {
  bool _isSending = false;
  bool hasError = false;
  int? errorStatusCode;
  String? errorMessage;

  void _sendSolution() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString('url')!;
    final url = Uri.parse(savedUrl);
    final calculatedData = ref.read(fetchedDataProvider).value!;
    final dataToSend = [];
    for (int j = 0; j < calculatedData.length; j++) {
      String id = calculatedData[j].id;
      String path = ref.read(pathListProvider)[j];
      List<Map<String, String>> steps = [];
      for (int i = 1; i < path.length; i = i + 7) {
        steps.add({'x': path[i], 'y': path[i + 2]});
      }
      Map<String, Object> requestBody = {};
      requestBody['id'] = id;
      Map<String, Object> stepsPathResult = {};
      stepsPathResult['steps'] = steps;
      stepsPathResult['path'] = path;
      requestBody['result'] = stepsPathResult;
      dataToSend.add(requestBody);
    }
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dataToSend),
      );
      if (response.statusCode != 200) {
        setState(() {
          hasError = true;
          errorStatusCode = response.statusCode;
          errorMessage = json.decode(response.body)['message'];
        });
      } else {
        setState(() {
          hasError = false;
        });
      }
      if (!context.mounted) {
        return;
      }
      setState(() {
        _isSending = false;
      });
      hasError
          ? () {}
          : Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const ResultListScreen();
                },
              ),
            );
    } catch (error) {
      errorMessage = error.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataList = ref.watch(fetchedDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Process screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: dataList.when(
          error: (error, stackTrace) {
            return Center(
              child: Text(
                error.toString(),
                textAlign: TextAlign.center,
              ),
            );
          },
          loading: () {
            return const Center(child: CircularProgressIndicator());
          },
          data: (data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _isSending
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: hasError
                              ? [
                                  Text(
                                    'Error occured: $errorStatusCode',
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    errorMessage!,
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ]
                              : [
                                  const Text(
                                    'All calculations has finished, you can send your results to server',
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    '100%',
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                        ),
                ),
                CustomButton(
                  func: _isSending
                      ? null
                      : () {
                          setState(() {
                            _isSending = true;
                            _sendSolution();
                          });
                        },
                  label: 'Send result ro server',
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
