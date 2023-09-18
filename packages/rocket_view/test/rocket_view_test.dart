import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_view/rocket_view.dart';

void main() {
  group('RocketView', () {
    testWidgets('RocketView displays loader when data is loading',
        (WidgetTester tester) async {
      final rocketModel = RocketModelData<int>();
      rocketModel.state = RocketState.loading;

      await tester.pumpWidget(
        MaterialApp(
          home: RocketView<int>(
            model: rocketModel,
            builder: (context, state) => const Text('Data is loading...'),
            loader: const CircularProgressIndicator(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Data is loading...'), findsNothing);

      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Data is loading...'), findsNothing);
    });

    testWidgets('RocketView displays data correctly when fetched',
        (WidgetTester tester) async {
      final rocketModel = RocketModelData<int>();
      rocketModel.state = RocketState.done;
      rocketModel.data = 5;

      await tester.pumpWidget(
        MaterialApp(
          home: RocketView<int>(
            model: rocketModel,
            builder: (context, state) => Text('Data is ${rocketModel.data}'),
          ),
        ),
      );

      expect(find.text('Data is 5'), findsOneWidget);
    });

    testWidgets('RocketView displays error message when an error occurs',
        (WidgetTester tester) async {
      final rocketModel = RocketModelData<int>();

      await tester.pumpWidget(
        MaterialApp(
          home: RocketView<int>(
            model: rocketModel,
            call: () {
              rocketModel.state = RocketState.failed;
              rocketModel.exception = RocketException(
                exception: 'Error fetching data',
                statusCode: 404,
                response: 'Data not found',
              );
            },
            builder: (context, state) => Text('Data is ${rocketModel.data}'),
            onError: (error, reload) => Text('Error: ${error.exception}'),
            loader: const CircularProgressIndicator(),
          ),
        ),
      );

      expect(find.text('Error: Error fetching data'), findsOneWidget);
    });

    testWidgets('RocketView calls reload function when Retry button is pressed',
        (WidgetTester tester) async {
      final rocketModel = RocketModelData<int>();
      rocketModel.state = RocketState.failed;
      rocketModel.exception = RocketException(
        exception: 'Error fetching data',
        statusCode: 404,
        response: 'Data not found',
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RocketView<int>(
            model: rocketModel,
            call: () async {},
            builder: (context, state) => Text('Data is ${rocketModel.data}'),
            onError: (error, reload) => TextButton(
              onPressed: reload,
              child: Text('Error: ${error.exception}. Tap to retry.'),
            ),
            loader: const CircularProgressIndicator(),
          ),
        ),
      );
      expect(rocketModel.state == RocketState.failed, isTrue);
      await tester.tap(find.byType(TextButton));
      expect(rocketModel.state == RocketState.loading, isTrue);
      expect(rocketModel.exception.statusCode, equals(404));
    });

    testWidgets('RocketView calls call function when CallType is callAsFuture',
        (WidgetTester tester) async {
      final rocketModel = RocketModelData<int>();
      rocketModel.state = RocketState.done;
      var callFunctionCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: RocketView<int>(
            model: rocketModel,
            builder: (context, state) => Text('Data is ${rocketModel.data}'),
            call: () {
              callFunctionCalled = true;
            },
            callType: CallType.callAsFuture,
          ),
        ),
      );

      expect(callFunctionCalled, isTrue);
    });

    testWidgets(
        'RocketView does not call call function when CallType is callIfModelEmpty and model is not empty',
        (WidgetTester tester) async {
      final rocketModel = RocketModelData<int>();
      rocketModel.state = RocketState.done;
      rocketModel.data = 5;
      rocketModel.existData = true;
      var callFunctionCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: RocketView<int>(
            model: rocketModel,
            builder: (context, state) => Text('Data is ${rocketModel.data}'),
            call: () {
              callFunctionCalled = true;
            },
            callType: CallType.callIfModelEmpty,
          ),
        ),
      );

      expect(callFunctionCalled, isFalse);
    });

    testWidgets(
        'RocketView calls call function when CallType is callIfModelEmpty and model is empty',
        (WidgetTester tester) async {
      final rocketModel = RocketModelData<int>();
      rocketModel.state = RocketState.done;

      var callFunctionCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: RocketView<int>(
            model: rocketModel,
            builder: (context, state) => Text('Data is ${rocketModel.data}'),
            call: () {
              callFunctionCalled = true;
            },
            callType: CallType.callIfModelEmpty,
          ),
        ),
      );

      expect(callFunctionCalled, isTrue);
    });
  });
}

class RocketModelData<T> extends RocketModel<T> {
  int? data;
}
