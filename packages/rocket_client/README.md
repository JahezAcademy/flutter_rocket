# Rocket Client

Rocket Client is a Dart package that provides a simple and easy-to-use HTTP client. It is built on top of the `http` package and provides additional features such as handling Rocket models, inspecting raw response data, and handling exceptions.


## Usage


Create an instance of the `RocketClient` class and use its `request` method to send HTTP requests:

```dart
final rocket = RocketClient(url: 'https://jsonplaceholder.typicode.com');

final response = await rocket.request('posts', method: HttpMethods.get);

print(response);
```

You can also provide a `RocketModel` to the `request` method to automatically handle the response data:

```dart
final rocket = RocketClient(url: 'https://jsonplaceholder.typicode.com');

final post = Post();

await rocket.request('posts/1', model: post, method: HttpMethods.get);

print(post.toJson());
```

The `sendFile` method can be used to send files to the server:

```dart
final rocket = RocketClient(url: 'https://example.com');

final response = await rocket.sendFile('upload', files: {'file': '/path/to/my/file.jpg'});

print(response);
```

## API Reference

### RocketClient

#### `RocketClient({required String url, Map<String, String> headers = const {}, bool setCookies = false})`

Creates a new instance of the `RocketClient` class.

- `url`: The base URL for the API.
- `headers`: Additional headers to be sent with every request.
- `setCookies`: Whether to set cookies received from the server in subsequent requests.

#### `Future<dynamic> request<T>(String endpoint, {RocketModel<T>? model, HttpMethods method = HttpMethods.get, RocketDataCallback? inspect, List<String>? targetData, Map<String, dynamic>? data, Map<String, dynamic>? params})`

Sends an HTTP request to the specified `endpoint` using the specified HTTP `method`.

- `endpoint`: The endpoint to send the request to.
- `model`: An optional `RocketModel` to handle the response data.
- `method`: The HTTP method to use.
- `inspect`: A function to inspect the raw response data before it is processed.
- `targetData`: A list of keys that will be used to extract a nested JSON object from the response data.
- `data`: The request body, which will be serialized to JSON before being sent.
- `params`: The query parameters to be added to the URL.

Returns a `Future` that resolves to the response data if model provided return it with data, Otherwise return json if can convert response, or string if can't convert to json response.

#### `Future<dynamic> sendFile(String endpoint, {String id = "", HttpMethods method = HttpMethods.post, Map<String, String>? fields, Map<String, String>? files})`

Sends a file or files to the specified `endpoint` and returns the response as a `Future`.

- `endpoint`: The endpoint to send the file(s) to.
- `id`: An optional ID to be included in the URL.
- `method`: The HTTP method to use.
- `fields`: Additional fields to be sent along with the file(s).
- `files`: The file(s) to be sent.

Returns a `Future` that resolves to the processed response data.

### HttpMethods

An enum representing the HTTP methods.

- `get`: The GET method.
- `post`: The POST method.
- `put`: The PUT method.
- `delete`: The DELETE method.
## Conclusion

Rocket Client provides a simple and powerful way to send HTTP requests in Dart. Its easy-to-use API and support for Rocket models make it an excellent choice for building Dart applications that communicate with APIs. If you have any questions or issues, feel free to check out the [Rocket Client GitHub repository](https://github.com/JahezAcademy/flutter_rocket/rocket_client) or ask for help on the [flutter_rocket package Discussions](https://github.com/JahezAcademy/flutter_rocket/discussions).