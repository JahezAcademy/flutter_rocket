# Rocket Client

Rocket Client is a Dart package that provides a simple and easy-to-use HTTP client. It is built on top of the `http` package and provides additional features such as handling Rocket models, inspecting raw response data, and handling exceptions.


## Usage


Create an instance of the `RocketClient` class and use its `request` method to send HTTP requests:

```dart
final rocket = RocketClient(url: 'https://jsonplaceholder.typicode.com');

// Default method is HttpMethods.get
final response = await rocket.request('posts');

print(response.apiResponse);
```

You can also provide a `RocketModel` to the `request` method to automatically handle the response data:

```dart
final rocket = RocketClient(url: 'https://jsonplaceholder.typicode.com');

final post = Post();

await rocket.request('posts/1', model: post);

print(post.toJson());
```

### Interceptors

You can add interceptors to modify requests before they are sent or responses after they are received:

```dart
final client = RocketClient(
  url: 'https://api.example.com',
  beforeRequest: (request) {
    request.headers['Authorization'] = 'Bearer token';
    return request;
  },
  afterResponse: (model) {
    print('Response status: ${model.statusCode}');
    return model;
  },
);
```

The `sendFile` method can be used to send files to the server:

```dart
final rocket = RocketClient(url: 'https://example.com');

final response = await rocket.sendFile('upload', files: {'file': '/path/to/my/file.jpg'});

print(response);
```

## API Reference

### RocketClient

#### `RocketClient({required String url, Map<String, String>? headers, bool setCookies = false, ...})`

Creates a new instance of the `RocketClient` class.

- `url`: The base URL for the API.
- `headers`: Additional headers to be sent with every request.
- `setCookies`: Whether to set cookies received from the server in subsequent requests.
- `beforeRequest`: Optional `RequestInterceptor` to modify outgoing requests.
- `afterResponse`: Optional `ResponseInterceptor` to modify incoming model responses.
- `globalRetryOptions`: Defaults for retrying failed requests.

#### `Future<RocketModel> request<T>(String endpoint, {RocketModel<T>? model, HttpMethods method = HttpMethods.get, RocketDataCallback? inspect, List<String>? target, Map<String, dynamic>? data, Map<String, dynamic>? params, ...})`

Sends an HTTP request to the specified `endpoint` using the specified HTTP `method`.

- `endpoint`: The endpoint to send the request to.
- `model`: An optional `RocketModel` to handle the response data.
- `method`: The HTTP method to use (defaults to `HttpMethods.get`).
- `inspect`: A function to extract or manipulate the raw response data before model passing.
- `target`: A list of keys that will be used to extract a nested JSON object from the response.
- `data`: The request body, which will be serialized to JSON before being sent.
- `params`: The query parameters to be added to the URL.
- `cache`: Allows caching the response data for faster subsequent retrievals.

Returns a `Future` resolving to the updated `model` if provided, or a generic `RocketResponse` if no model was provided.

#### `Future<dynamic> sendFile(String endpoint, {Map<String, String>? fields, Map<String, String>? files, String id = "", HttpMethods method = HttpMethods.post})`

Sends a file or multipart request to the specified `endpoint`.

- `endpoint`: The endpoint to send the file(s) to.
- `fields`: Additional key-value pairs (form fields) to be sent along with the file(s).
- `files`: The file(s) to be sent where the key is the field name and value is the path.
- `id`: An optional ID to be appended to the URL.
- `method`: The HTTP method to use (defaults to `HttpMethods.post`).

Returns a `Future` resolving to the decoded JSON response, or string if decoding fails.

### HttpMethods

An enum representing the HTTP methods.

- `get`: The GET method.
- `post`: The POST method.
- `put`: The PUT method.
- `delete`: The DELETE method.
## Conclusion

Rocket Client provides a simple and powerful way to send HTTP requests in Dart. Its easy-to-use API and support for Rocket models make it an excellent choice for building Dart applications that communicate with APIs. If you have any questions or issues, feel free to check out the [Rocket Client GitHub repository](https://github.com/JahezAcademy/flutter_rocket/tree/dev/packages/rocket_client) or ask for help on the [flutter_rocket package Discussions](https://github.com/JahezAcademy/flutter_rocket/discussions).