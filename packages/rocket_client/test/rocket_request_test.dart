import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rocket_client/rocket_client.dart';
import 'package:rocket_model/rocket_model.dart';

import 'post_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RocketClient', () {
    late MockClient mockClient;
    late RocketClient client;

    setUp(() {
      mockClient = MockClient((request) async {
        // Default mock response
        return http.Response(json.encode({'id': 1, 'title': 'Test Post'}), 200);
      });
      client = RocketClient(url: 'https://example.com', client: mockClient);
    });

    test('request - should get data using model from endpoint', () async {
      final model = Post();
      await client.request('posts/1', model: model);
      expect(model.state, RocketState.done);
      expect(model.id, 1);
    });

    test('request - should get list data using model from endpoint', () async {
      mockClient = MockClient((request) async {
        return http.Response(
            json.encode([
              {'id': 1, 'title': 'Post 1'},
              {'id': 2, 'title': 'Post 2'},
            ]),
            200);
      });
      client = RocketClient(url: 'https://example.com', client: mockClient);

      final model = Post();
      await client.request('posts', model: model);
      expect(model.state, RocketState.done);
      expect(model.all!.isNotEmpty, isTrue);
    });

    test('request - should handle errors', () async {
      mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });
      client = RocketClient(url: 'https://example.com', client: mockClient);

      final model = Post();
      await client.request('posts/invalid', model: model);
      expect(model.state, RocketState.failed);
      expect(model.exception, isA<RocketException>());
      expect(model.exception.statusCode != 200, isTrue);
    });

    test('request - should get data from endpoint', () async {
      final data = await client.request('posts/1');
      expect(data.apiResponse, isA<Map>());
      expect(data.apiResponse['id'], 1);
    });

    test('request - should get list data from endpoint', () async {
      mockClient = MockClient((request) async {
        return http.Response(
            json.encode([
              {'id': 1, 'title': 'Post 1'},
              {'id': 2, 'title': 'Post 2'},
            ]),
            200);
      });
      client = RocketClient(url: 'https://example.com', client: mockClient);

      final data = await client.request('posts');
      expect(data.apiResponse, isA<List>());
      expect(data.apiResponse.isNotEmpty, isTrue);
    });

    test('request - should get list data from endpoint using inspect', () async {
      mockClient = MockClient((request) async {
        return http.Response(
            json.encode({
              'results': [
                {'id': 1, 'title': 'Post 1'},
                {'id': 2, 'title': 'Post 2'},
              ]
            }),
            200);
      });
      client = RocketClient(url: 'https://example.com', client: mockClient);

      final data = await client.request('posts',
          inspect: (data) => data['results']);
      expect(data.apiResponse, isA<List>());
      expect(data.apiResponse.isNotEmpty, isTrue);
    });

    test('request - should get list data from endpoint using targetData',
        () async {
      mockClient = MockClient((request) async {
        return http.Response(
            json.encode({
              'data': {
                'items': [
                  {'id': 1, 'title': 'Post 1'},
                  {'id': 2, 'title': 'Post 2'},
                ]
              }
            }),
            200);
      });
      client = RocketClient(url: 'https://example.com', client: mockClient);

      final data =
          await client.request('posts', target: ['data', 'items']);
      expect(data.apiResponse, isA<List>());
      expect(data.apiResponse.isNotEmpty, isTrue);
    });

    test('request - should use beforeRequest interceptor', () async {
      bool interceptorCalled = false;
      client = RocketClient(
        url: 'https://example.com',
        client: mockClient,
        beforeRequest: (request) {
          interceptorCalled = true;
          request.headers['Authorization'] = 'Bearer token';
          return request;
        },
      );

      await client.request('posts/1');
      expect(interceptorCalled, isTrue);
    });

    test('request - should use afterResponse interceptor', () async {
      bool interceptorCalled = false;
      client = RocketClient(
        url: 'https://example.com',
        client: mockClient,
        afterResponse: (model) {
          interceptorCalled = true;
          return model;
        },
      );

      await client.request('posts/1');
      expect(interceptorCalled, isTrue);
    });

    test('request - should accept cache parameters', () async {
      // Test that cache parameters are accepted (actual caching requires integration test)
      // Mock SharedPreferences to avoid MissingPluginException
      SharedPreferences.setMockInitialValues({});
      
      final model = Post();
      await client.request('posts/1', model: model, cache: true, cacheDuration: const Duration(minutes: 5));
      expect(model.state, RocketState.done);
    });

    test('request - should handle retry on error', () async {
      int callCount = 0;
      mockClient = MockClient((request) async {
        callCount++;
        if (callCount <= 2) {
          return http.Response('Server Error', 503);
        }
        return http.Response(json.encode({'id': 1, 'title': 'Success'}), 200);
      });
      client = RocketClient(
        url: 'https://example.com',
        client: mockClient,
        globalRetryOptions: RetryOptions(
          retries: 3,
          delay: (_) => const Duration(milliseconds: 10),
        ),
      );

      final model = Post();
      await client.request('posts/1', model: model);

      // Should have retried
      expect(callCount, greaterThan(1));
    });
  });
}
