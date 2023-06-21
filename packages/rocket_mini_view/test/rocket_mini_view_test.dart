import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_listenable/rocket_listenable.dart';
import 'package:rocket_mini_view/rocket_mini_view.dart';

void main() {
  group('RocketMiniView', () {
    testWidgets('rebuilds when RocketListenable changes',
        (WidgetTester tester) async {
      final listenable = _TestListenable();
      var buildCount = 0;
      await tester.pumpWidget(
        RocketMiniView(
          value: listenable,
          builder: () {
            buildCount++;
            return Container();
          },
        ),
      );
      expect(buildCount, equals(1));
      listenable.notify();
      await tester.pump();
      expect(buildCount, equals(2));
    });

    testWidgets('rebuilds when merged RocketListenable changes',
        (WidgetTester tester) async {
      final listenable1 = _TestListenable();
      final listenable2 = _TestListenable();
      final mergedListenable = RocketValue.merge([listenable1, listenable2]);
      var buildCount = 0;
      await tester.pumpWidget(
        RocketMiniView(
          value: mergedListenable,
          builder: () {
            buildCount++;
            return Container();
          },
        ),
      );
      expect(buildCount, equals(1));
      listenable1.notifyMerges();
      await tester.pump();
      expect(buildCount, equals(2));
      listenable2.notifyMerges();
      await tester.pump();
      expect(buildCount, equals(3));
    });

    testWidgets('updates listeners when value parameter changes',
        (WidgetTester tester) async {
      final listenable1 = _TestListenable();
      final listenable2 = _TestListenable();
      var buildCount = 0;
      await tester.pumpWidget(
        RocketMiniView(
          value: listenable1,
          builder: () {
            buildCount++;
            return Container();
          },
        ),
      );
      expect(buildCount, equals(1));
      await tester.pumpWidget(
        RocketMiniView(
          value: listenable2,
          builder: () {
            buildCount++;
            return Container();
          },
        ),
      );
      expect(buildCount, equals(2));
      listenable1.notify();
      await tester.pump();
      expect(buildCount, equals(2));
      listenable2.notify();
      await tester.pump();
      expect(buildCount, equals(3));
    });

    testWidgets('unregisters listener when widget is disposed',
        (WidgetTester tester) async {
      final listenable = _TestListenable();
      var buildCount = 0;
      await tester.pumpWidget(
        RocketMiniView(
          value: listenable,
          builder: () {
            buildCount++;
            return Container();
          },
        ),
      );
      expect(buildCount, equals(1));
      listenable.notify();
      await tester.pump();
      expect(buildCount, equals(2));
      await tester.pumpWidget(Container());
      listenable.notify();
      await tester.pump();
      expect(buildCount, equals(2));
    });
  });
}

class _TestListenable extends RocketListenable {
  void notify() {
    callListener(rocketMiniRebuild);
  }

  void notifyMerges() {
    callListener(rocketMergesRebuild);
  }
}
