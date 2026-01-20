import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rocket_client/rocket_client.dart';
import 'package:rocket_model/rocket_model.dart';
import 'post_model.dart';

void main() {
  group('MockRocketClient Tests', () {
    test('request - success', () async {
      final mockClient = MockClient((request) async {
        return http.Response(json.encode({'id': 1, 'title': 'Test Post'}), 200);
      });

      final client =
          RocketClient(url: 'https://example.com', client: mockClient);
      final model = Post();

      await client.request('posts/1', model: model);

      expect(model.state, RocketState.done);
      expect(model.id, 1);
      expect(model.title, 'Test Post');
    });

    test('request - error handling', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final client =
          RocketClient(url: 'https://example.com', client: mockClient);
      final model = Post();

      await client.request('posts/999', model: model);

      expect(model.state, RocketState.failed);
      expect(model.exception.statusCode, 404);
      expect(model.exception.response, 'Not Found');
    });

    test('request - target data extraction', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
            json.encode({
              'status': 'success',
              'data': {'id': 1, 'title': 'Nested Post'}
            }),
            200);
      });

      final client =
          RocketClient(url: 'https://example.com', client: mockClient);
      final model = Post();

      await client.request('posts/1', model: model, target: ['data']);

      expect(model.state, RocketState.done);
      expect(model.id, 1);
      expect(model.title, 'Nested Post');
    });
  });
}
