import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:rocket_client/rocket_client.dart';

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
  final client = RocketClient(url: 'https://jsonplaceholder.typicode.com');
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
                      _makeRequest(context, "posts");
                    },
                    child: const Text('Make Request'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // pass wrong endpoint for produce error
                      _makeRequest(context, "postss");
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
    final response = await client.request(
      endpoint,
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
            title: const Text('Response'),
            content: Text(json.encode(response)),
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
