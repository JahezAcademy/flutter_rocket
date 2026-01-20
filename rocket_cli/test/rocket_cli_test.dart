import 'package:test/test.dart';
import 'package:rocket_cli/rocket_cli.dart';

void main() {
  group('EString Extension Tests', () {
    test('firstUpper converts first character to uppercase', () {
      expect('hello'.firstUpper, 'Hello');
      expect('world'.firstUpper, 'World');
      expect(''.firstUpper, '');
    });

    test('camel converts various formats to camelCase', () {
      expect('hello_world'.camel, 'helloWorld');
      expect('hello-world'.camel, 'helloWorld');
      expect('hello world'.camel, 'helloWorld');
      expect('HelloWorld'.camel, 'helloWorld');
      expect(''.camel, '');
    });
  });

  group('Generator Tests', () {
    late Generator generator;
    late ModelsController controller;

    setUp(() {
      generator = Generator();
      controller = ModelsController();
    });

    test('Generates primitive fields correctly', () async {
      const jsonStr =
          '{"name": "John", "age": 30, "is_active": true, "score": 95.5}';
      await generator.generate(jsonStr, 'User', controller);

      expect(controller.models.length, 1);
      final result = controller.models.first.result;

      expect(result, contains('String? name;'));
      expect(result, contains('int? age;'));
      expect(result, contains('bool? isActive;'));
      expect(result, contains('double? score;'));
      expect(result, contains('name = json[userNameField];'));
    });

    test('Detects DateTime fields', () async {
      const jsonStr = '{"created_at": "2024-01-20T10:00:00Z"}';
      await generator.generate(jsonStr, 'Post', controller);

      expect(controller.models.length, 1);
      final result = controller.models.first.result;

      expect(result, contains('DateTime? createdAt;'));
      expect(result,
          contains('DateTime.tryParse(json[postCreatedAtField].toString())'));
      expect(result, contains('createdAt?.toIso8601String()'));
    });

    test('Handles nested objects', () async {
      const jsonStr = '{"user": {"id": 1, "name": "John"}}';
      await generator.generate(jsonStr, 'Root', controller);

      // Should generate 2 models: User and Root
      expect(controller.models.length, 2);

      final rootModel =
          controller.models.firstWhere((m) => m.name == 'Root').result;
      final userModel =
          controller.models.firstWhere((m) => m.name == 'User').result;

      expect(rootModel, contains('User? user;'));
      expect(userModel, contains('int? id;'));
      expect(userModel, contains('String? name;'));
    });

    test('Handles list of primitives', () async {
      const jsonStr = '{"tags": ["flutter", "dart"]}';
      await generator.generate(jsonStr, 'Item', controller);

      final result = controller.models.first.result;
      expect(result, contains('List<String>? tags;'));
      expect(result, contains('json[itemTagsField]?.cast<String>()'));
    });

    test('Handles list of objects', () async {
      const jsonStr = '{"comments": [{"id": 1, "text": "nice"}]}';
      await generator.generate(jsonStr, 'Post', controller);

      expect(controller.models.length, 2);
      final postResult =
          controller.models.firstWhere((m) => m.name == 'Post').result;
      final commentsResult =
          controller.models.firstWhere((m) => m.name == 'Comments').result;

      expect(postResult, contains('Comments? comments;'));
      expect(
          postResult, contains('comments!.setMulti(json[postCommentsField])'));
      expect(commentsResult, contains('int? id;'));
      expect(commentsResult, contains('String? text;'));
    });

    test('Handles null values', () async {
      const jsonStr = '{"data": null}';
      await generator.generate(jsonStr, 'Response', controller);

      final result = controller.models.first.result;
      expect(result, contains('dynamic? data;'));
    });

    test('Prevents duplicate class generation', () async {
      // We'll simulate a case where a class name might be reused
      await generator.generate('{"id": 1}', 'User', controller);
      await generator.generate('{"name": "John"}', 'User', controller);

      expect(controller.models.length, 1);
    });

    test('Handles complex nested lists (List of List of primitives)', () async {
      const jsonStr = '{"matrix": [[1, 2], [3, 4]]}';
      await generator.generate(jsonStr, 'Matrix', controller);

      final result = controller.models.first.result;
      expect(result, contains('List<List<int>>? matrix;'));
      expect(result, contains('json[matrixMatrixField]?.cast<List<int>>()'));
    });

    test('Handles deeply nested objects', () async {
      const jsonStr = '{"a": {"b": {"c": {"d": 1}}}}';
      await generator.generate(jsonStr, 'Deep', controller);

      // Deep, A, B, C models should be generated
      expect(controller.models.length, 4);
      expect(controller.models.any((m) => m.name == 'Deep'), isTrue);
      expect(controller.models.any((m) => m.name == 'A'), isTrue);
      expect(controller.models.any((m) => m.name == 'B'), isTrue);
      expect(controller.models.any((m) => m.name == 'C'), isTrue);
    });

    test('Gracefully handles malformed JSON', () async {
      const jsonStr = '{"name": "John", "age": }'; // Malformed
      await generator.generate(jsonStr, 'Error', controller);

      expect(controller.models, isEmpty);
    });

    test('Handles empty list correctly', () async {
      const jsonStr = '{"items": []}';
      await generator.generate(jsonStr, 'Empty', controller);

      final result = controller.models.first.result;
      expect(result, contains('List<dynamic>? items;'));
    });

    test('Generates updateFields with selective rebuild logic', () async {
      const jsonStr = '{"title": "Hello", "body": "World"}';
      await generator.generate(jsonStr, 'Post', controller);

      final result = controller.models.first.result;

      // Check for fields list initialization
      expect(result, contains('List<String> fields = [];'));

      // Check for selective field updates
      expect(result, contains('if (titleField != null) {'));
      expect(result, contains('title = titleField;'));
      expect(result, contains('fields.add(postTitleField);'));

      expect(result, contains('if (bodyField != null) {'));
      expect(result, contains('body = bodyField;'));
      expect(result, contains('fields.add(postBodyField);'));

      // Check for rebuildWidget call with fields
      expect(
          result,
          contains(
              'rebuildWidget(fromUpdate: true, fields: fields.isEmpty ? null : fields);'));
    });
  });
}
