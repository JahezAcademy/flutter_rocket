import 'package:example/views/post_view.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mvc_rocket/mvc_rocket.dart';

import 'dummy_data.dart';
import 'rocket_request_test.dart';

void main() {
  testWidgets('Test Post view', (tester) async {
    const String baseUrl = 'https://jsonplaceholder.typicode.com';
    // Create request object
    RocketRequestTest request = RocketRequestTest(baseUrl);
    RocketController().add(rocketRequestKey, request);
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: PostExample(
      title: 'test',
    )));
    // Check loading
    expect(find.bySubtype<CircularProgressIndicator>(), findsOneWidget);
    // After 1 second data loaded
    await tester.pump(const Duration(seconds: 1));
    expect(find.text(postData[0]['title']), findsOneWidget);
    // Click to refresh for reload data
    await tester.tap(find.byIcon(Icons.data_usage));
    await tester.pump();
    // Check loading
    expect(find.bySubtype<CircularProgressIndicator>(), findsOneWidget);
    // After 1 second data loaded
    await tester.pump(const Duration(seconds: 1));
    expect(find.text(postData[0]['title']), findsOneWidget);
  });
}
