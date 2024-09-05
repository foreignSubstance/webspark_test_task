import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:webspark_test_task/providers/fetch_data_provider.dart';
import 'package:webspark_test_task/screens/process_screen.dart';
import 'package:webspark_test_task/widgets/custom_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _urlController = TextEditingController();
  String? _rawUrl;

  @override
  void initState() {
    super.initState();
    _retrieveUrl();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _saveUrl() async {
    ref.read(rawUrlProvider.notifier).state = _rawUrl!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('url', _rawUrl!);
  }

  void _retrieveUrl() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rawUrl = prefs.getString('url');
      _urlController.text = _rawUrl ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home screen')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Set valid API base URL in order to continue'),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.compare_arrows),
              ),
              controller: _urlController,
              onChanged: (value) {
                setState(() {
                  _rawUrl = value;
                });
              },
            ),
            const Spacer(),
            CustomButton(
              func: () async {
                _saveUrl();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ProcessScreen();
                    },
                  ),
                );
              },
              label: 'Start counting process',
            ),
          ],
        ),
      ),
    );
  }
}
