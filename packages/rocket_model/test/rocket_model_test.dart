import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_model/rocket_model.dart';
import 'test_model.dart';

void main() {
  group('RocketModel', () {
    test('sets state correctly', () {
      final model = TestModel();
      expect(model.state, equals(RocketState.done));
      model.state = RocketState.done;
      expect(model.state, equals(RocketState.done));
      model.state = RocketState.loading;
      expect(model.state, equals(RocketState.loading));
      model.loadingChecking = true;
      model.state = RocketState.loading;
      expect(model.state, equals(RocketState.loading));
    });

    test('sets exception correctly', () {
      final model = TestModel();
      expect(model.exception.exception, equals(''));
      model.setException(RocketException(exception: 'Test exception'));
      expect(model.exception.exception, equals('Test exception'));
      expect(model.state, equals(RocketState.failed));
    });

    test('rebuilds widget correctly', () {
      final model = TestModel();
      var rebuildCount = 0;
      model.registerListener(rocketRebuild, () => rebuildCount++);
      expect(rebuildCount, equals(0));
      model.rebuildWidget();
      expect(rebuildCount, equals(1));
      model.rebuildWidget(fromUpdate: true);
      expect(rebuildCount, equals(2));
      model.rebuildWidget(fromUpdate: true);
      expect(rebuildCount, equals(3));
    });

    test('adds and deletes items correctly', () {
      final model = TestModel();
      model.all = [TestModel(id:1), TestModel(id:2), TestModel(id:3)];
      expect(model.all!.length, equals(3));
      model.delItem(1);
      expect(model.all!.length, equals(2));
      expect(model.all![0].id, equals(1));
      expect(model.all![1].id, equals(3));
      model.addItem(TestModel(id:4));
      expect(model.all!.length, equals(3));
      expect(model.all![0].id, equals(1));
      expect(model.all![1].id, equals(3));
      expect(model.all![2].id, equals(4));
    });

    test('maps to instance correctly', () {
      final model = TestModel();
      final data = {'id': 1, 'name': 'Test model'};
      model.fromJson(data);
      expect(model.id, equals(1));
      expect(model.name, equals('Test model'));
    });

    test('sets multi correctly', () {
      final model = TestModel();
      final data = [
        {'id': 1, 'name': 'Test model 1'},
        {'id': 2, 'name': 'Test model 2'},
        {'id': 3, 'name': 'Test model 3'}
      ];
      model.setMulti(data);
      expect(model.all!.length, equals(3));
      expect(model.all![0].id, equals(1));
      expect(model.all![0].name, equals('Test model 1'));
      expect(model.all![1].id, equals(2));
      expect(model.all![1].name, equals('Test model 2'));
      expect(model.all![2].id, equals(3));
      expect(model.all![2].name, equals('Test model 3'));
      expect(model.existData, equals(true));
      expect(model.state, equals(RocketState.done));
    });

    test('to/from JSON', () {
      final model = TestModel();
      final data = {'id': 1, 'name': 'Test model'};
      model.fromJson(data);
      expect(model.id, equals(1));
      expect(model.name, equals('Test model'));
      final json = model.toJson();
      expect(json, equals({'id': null, 'name': null}));
    });
  });
}