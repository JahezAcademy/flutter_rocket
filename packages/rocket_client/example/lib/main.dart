import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:rocket_client/rocket_client.dart';
import 'package:rocket_model/rocket_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rocket Client Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RocketClientExample(),
    );
  }
}

class RocketClientExample extends StatefulWidget {
  const RocketClientExample({super.key});

  @override
  RocketClientExampleState createState() => RocketClientExampleState();
}

class RocketClientExampleState extends State<RocketClientExample> {
  final client = RocketClient(url: 'https://dummyjson.com');
  bool isLoading = false;
  bool isFailed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocket Client Example'),
      ),
      body: Center(
        child: isLoading
            // ignore: prefer_const_constructors
            ? CircularProgressIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _makeRequest(context, "products");
                    },
                    child: const Text('Make Request'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // pass wrong endpoint for produce error
                      _makeRequest(context, "productsss");
                    },
                    child: const Text('Make Failed Request'),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _makeRequest(BuildContext context, String endpoint) async {
    isLoading = true;
    isFailed = false;
    setState(() {});
    // Make a GET request to the /posts endpoint
    final RocketModel response = await client.request(
      endpoint,
      target: ['products'],
      retries: 5,
      retryWhen: (r) => r.statusCode != 200,
      onRetry: (p0, p1, p2) {
        log("Retry $p2");
      },
      onError: (response, statusCode) {
        isFailed = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Column(
          children: [
            const Text("Failed"),
            Text("response : $response & status code: $statusCode"),
          ],
        )));
      },
    );
    isLoading = false;
    setState(() {});
    // Display the response in a dialog
    if (!isFailed) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Response : ${response.statusCode}'),
            content: Text(json.encode(response.apiResponse)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
