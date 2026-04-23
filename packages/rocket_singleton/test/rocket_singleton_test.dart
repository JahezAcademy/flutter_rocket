import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_singleton/src/rocket_singleton_base.dart';

class TestModel {
  String name;

  TestModel(this.name);
}

void main() {
  setUp(() {
    Rocket.resetForTesting();
  });

  group('Rocket', () {
    test('add and get', () {
      final model = TestModel('test');
      final addedModel = Rocket.add(model);
      expect(model, equals(addedModel));
      expect(Rocket.get<TestModel>(), equals(model));
    });

    test('get by key', () {
      final model = TestModel('test');
      Rocket.add(model, key: 'myModel');
      expect(Rocket.get<TestModel>('myModel'), equals(model));
    });

    test('get by type', () {
      // Use different types to test type-based retrieval
      final model1 = TestModel('test1');
      final model2 = TestModel('test2');
      Rocket.add(model1, key: 'model1');
      Rocket.add(model2, key: 'model2');
      final models = Rocket.getByType<TestModel>();
      expect(models.length, equals(2));
      expect(models.contains(model1), isTrue);
      expect(models.contains(model2), isTrue);
    });

    test('remove', () {
      final model = TestModel('test');
      Rocket.add(model);
      Rocket.remove<TestModel>();
      expect(Rocket.get<TestModel>(), isNull);
    });

    test('remove by key', () {
      final model = TestModel('test');
      Rocket.add(model, key: 'myModel');
      Rocket.remove<TestModel>(key: 'myModel');
      expect(Rocket.get<TestModel>('myModel'), isNull);
    });

    test('remove by predicate', () {
      final model1 = TestModel('test1');
      final model2 = TestModel('test2');
      Rocket.add(model1);
      Rocket.add(model2);
      Rocket.removeWhere((key, value) => (value as TestModel).name == 'test1');
      expect(Rocket.getByType<TestModel>().length, equals(1));
      expect(Rocket.get<TestModel>(), equals(model2));
    });

    test('has key', () {
      final model = TestModel('test');
      Rocket.add(model, key: 'myModel');
      expect(Rocket.hasKey('myModel'), isTrue);
      expect(Rocket.hasKey('otherModel'), isFalse);
    });

    test('has type', () {
      final model = TestModel('test');
      Rocket.add(model);
      expect(Rocket.hasType<TestModel>(), isTrue);
      expect(Rocket.hasType<String>(), isFalse);
    });

    test('get first by type', () {
      // Use different types to test type-based retrieval
      final model1 = TestModel('test1');
      final model2 = TestModel('test2');
      Rocket.add(model1, key: 'model1');
      Rocket.add(model2, key: 'model2');
      final result = Rocket.getFirstByType<TestModel>();
      expect(result, isNotNull);
      // Result should be one of the added models (HashMap doesn't guarantee order)
      expect(result!.name, anyOf(equals('test1'), equals('test2')));
    });

    test('remove all', () {
      final model1 = TestModel('test1');
      final model2 = TestModel('test2');
      Rocket.add(model1);
      Rocket.add(model2);
      Rocket.clear();
      expect(Rocket.getByType<TestModel>().length, equals(0));
    });

    test('get non-existent key returns null', () {
      expect(Rocket.get<TestModel>('nonExistent'), isNull);
    });

    test('get non-existent type returns null', () {
      expect(Rocket.get<TestModel>(), isNull);
    });
  });
}
