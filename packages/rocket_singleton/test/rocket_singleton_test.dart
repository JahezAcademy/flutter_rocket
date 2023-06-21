import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_singleton/src/rocket_singleton_base.dart';

class TestModel {
  String name;

  TestModel(this.name);
}

void main() {
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
      Rocket.clear();
      final model1 = TestModel('test1');
      final model2 = TestModel('test2');
      Rocket.add(model1);
      Rocket.add(model2);
      final models = Rocket.getByType<TestModel>();
      expect(models.length, equals(2));
      expect(models.contains(model1), equals(true));
      expect(models.contains(model2), equals(true));
    });

    test('remove', () {
      final model = TestModel('test');
      Rocket.add(model);
      Rocket.remove<TestModel>();
      expect(Rocket.get<TestModel>(), equals(null));
    });

    test('remove by key', () {
      final model = TestModel('test');
      Rocket.add(model, key: 'myModel');
      Rocket.remove<TestModel>(key: 'myModel');
      expect(Rocket.get<TestModel>('myModel'), equals(null));
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
      expect(Rocket.hasKey('myModel'), equals(true));
      expect(Rocket.hasKey('otherModel'), equals(false));
    });

    test('has type', () {
      final model = TestModel('test');
      Rocket.add(model);
      expect(Rocket.hasType<TestModel>(), equals(true));
      expect(Rocket.hasType<String>(), equals(false));
    });

    test('get first by type', () {
      final model1 = TestModel('test1');
      final model2 = TestModel('test2');
      Rocket.add(model1);
      Future.delayed(const Duration(seconds: 1)).whenComplete(() {
        Rocket.add(model2);
        expect(Rocket.getFirstByType<TestModel>(), equals(model1));
      });
    });

    test('remove all', () {
      final model1 = TestModel('test1');
      final model2 = TestModel('test2');
      Rocket.add(model1);
      Rocket.add(model2);
      Rocket.clear();
      expect(Rocket.getByType<TestModel>().length, equals(0));
    });
  });
}
