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
            : ElevatedButton(
                onPressed: () async {
                  isLoading = true;
                  setState(() {});
                  // Make a GET request to the /posts endpoint
                  final RocketModel response = await client
                      .request('products', targetData: ['products']);
                  isLoading = false;
                  setState(() {});
                  // Display the response in a dialog
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Response'),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text("Status Code :${response.statusCode}"),
                              Text(json.encode(response.apiResponse)),
                            ],
                          ),
                        ),
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
                },
                child: const Text('Make Request'),
              ),
      ),
    );
  }
}
