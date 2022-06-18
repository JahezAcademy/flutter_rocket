import 'package:example/models/photo_model.dart';
import 'package:example/models/post_model.dart';
import 'package:example/models/user_model.dart';
import 'package:example/views/post_view.dart';
import 'package:example/views/user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvc_rocket/mvc_rocket.dart';
import 'dummy_data.dart';
import 'fake_rocket_request.dart';

void main() {
  testWidgets('Test Post view (setup,refresh,update)', (tester) async {
    // Create request object
    RocketRequestTest request = RocketRequestTest(postData);
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
    expect(find.text(postData.first[postTitleField]), findsOneWidget);
    // Click to refresh for reload data
    await tester.tap(find.byIcon(Icons.data_usage));
    await tester.pump();
    // Check loading
    expect(find.bySubtype<CircularProgressIndicator>(), findsOneWidget);
    // After 1 second data loaded
    await tester.pump(const Duration(seconds: 1));
    expect(find.text(postData.first[postTitleField]), findsOneWidget);
    // Change first post title
    await tester.tap(find.byIcon(Icons.update));
    await tester.pump();
    // Title changed
    expect(find.text("This Title changed"), findsOneWidget);
  });

  testWidgets('Test user view (setup,refresh,update)', (tester) async {
    // Create request object
    RocketRequestTest request = RocketRequestTest(userData);
    RocketController().add(rocketRequestKey, request);
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: UserExample(
      title: 'test',
    )));
    // Check loading
    expect(find.bySubtype<CircularProgressIndicator>(), findsOneWidget);
    // After 2 second data loaded
    await tester.pump(const Duration(seconds: 1));
    expect(find.text("User :${userData.first[userNameField]}"), findsOneWidget);
    // Click to refresh for reload data
    await tester.tap(find.byIcon(Icons.get_app));
    await tester.pump();
    // Check loading
    expect(find.bySubtype<CircularProgressIndicator>(), findsOneWidget);
    // After 1 second data loaded
    await tester.pump(const Duration(seconds: 1));
    expect(find.text("User :${userData.first[userNameField]}"), findsOneWidget);
    // Change first username
    await tester.tap(find.byIcon(Icons.update));
    await tester.pump();
    // Name changed
    expect(find.text("User :Mohammed CHAHBOUN 💙"), findsOneWidget);
    // After 10 seconds data updated from API
    await tester.pump(const Duration(seconds: 10));
    expect(find.text("User :${userData.first[userNameField]}"), findsOneWidget);
  });

  testWidgets('Test Photo view (setup,refresh)', (tester) async {
    // Create request object
    RocketRequestTest request = RocketRequestTest(photoData);
    RocketController().add(rocketRequestKey, request);
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: PostExample(
      title: 'test',
    )));
    await tester.pump();
    // Check loading
    expect(find.bySubtype<CircularProgressIndicator>(), findsOneWidget);
    // After 1 second data loaded
    await tester.pump(const Duration(seconds: 1));
    expect(find.text(photoData.first[photoTitleField]), findsOneWidget);
    // Click to refresh for reload data
    await tester.tap(find.byIcon(Icons.data_usage));
    await tester.pump();
    // Check loading
    expect(find.bySubtype<CircularProgressIndicator>(), findsOneWidget);
    // After 1 second data loaded
    await tester.pump(const Duration(seconds: 1));
    expect(find.text(photoData.first[photoTitleField]), findsOneWidget);
  });
}
