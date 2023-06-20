import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_client/rocket_client.dart';
import 'package:rocket_model/rocket_model.dart';

import 'post_model.dart';

void main() {
  group('RocketClient', () {
    late RocketClient client;

    setUp(() {
      client = RocketClient(url: 'https://jsonplaceholder.typicode.com');
    });

    test('request - should get data from endpoint', () async {
      final model = Post();
      await client.request('posts/1', model: model);
      expect(model.state, RocketState.done);
      expect(model.id, 1);
    });

    test('request - should get list data from endpoint', () async {
      final model = Post();
      await client.request('posts', model: model);
      expect(model.state, RocketState.done);
      expect(model.all!.isNotEmpty, isTrue);
    });

    test('request - should handle errors', () async {
      final model = Post();
      await client.request('posts/invalid', model: model);
      expect(model.state, RocketState.failed);
      expect(model.exception, isA<RocketException>());
    });
  });
}
