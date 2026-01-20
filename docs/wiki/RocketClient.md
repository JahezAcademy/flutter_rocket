# RocketClient

`RocketClient` is a powerful HTTP client built into Flutter Rocket. It handles requests, responses, state transitions in models, and includes features like interceptors and caching.

## Basic Usage

Initialize the client with a base URL:

```dart
final client = RocketClient(url: 'https://api.example.com');
```

## Making Requests

Use the `request` method to fetch data. It automatically handles the `RocketModel` state.

```dart
await client.request(
  'posts',
  model: postModel,
  method: RocketMethods.get, // Default is GET
);
```

### Request Parameters
- `model`: The `RocketModel` that will store the response.
- `params`: Query parameters.
- `data`: Request body (for POST/PUT).
- `target`: If the data you want is nested in the JSON response (e.g., `['data', 'items']`).

## Interceptors

Interceptors allow you to run code before a request is sent or after a response is received.

```dart
final client = Rocketクライアント(
  url: 'https://api.example.com',
  beforeRequest: (request) {
    // Add Auth token
    request.headers['Authorization'] = 'Bearer your_token';
    return request;
  },
  afterResponse: (response) {
    // Log status or refresh token
    print('Status: ${response.statusCode}');
    return response;
  },
);
```

## Caching

Speed up your app by caching network responses.

1. **Initialize Caching**:
```dart
void main() async {
  await RocketCache.init();
  runApp(MyApp());
}
```

2. **Use in Request**:
```dart
client.request(
  'posts',
  model: postModel,
  cacheKey: 'posts_cache',
  cacheDuration: Duration(hours: 1),
);
```

## Multi-Part Requests (Files)

```dart
client.sendFile(
  'upload',
  fields: {'name': 'profile'},
  files: {'avatar': 'path/to/image.png'},
);
```
