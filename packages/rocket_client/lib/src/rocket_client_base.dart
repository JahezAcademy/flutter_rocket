import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:rocket_client/src/retry_options.dart';
import 'package:rocket_model/rocket_model.dart';

import 'extensions.dart';

typedef RocketDataCallback = Function(dynamic data)?;
typedef RocketOnError = void Function(dynamic response, int statusCode)?;

class RocketClient {
  final String url;
  final Map<String, String> headers;
  final bool setCookies;
  void Function(dynamic, int, String?)? onResponse;
  final RetryOptions globalRetryOptions;

  RocketClient(
      {required this.url,
      this.headers = const {},
      this.setCookies = false,
      this.globalRetryOptions = const RetryOptions(),
      this.onResponse});

  Future<RocketModel> _processData<T>(StreamedResponse response,
      {RocketModel<T>? model,
      RocketDataCallback inspect,
      List<String>? target,
      String? endpoint,
      RocketOnError onError}) async {
    String respDecoded = utf8.decode(await response.stream.toBytes());
    late dynamic result;
    try {
      result = json.decode(respDecoded);
    } catch (e) {
      result = respDecoded;
    }
    onResponse?.call(result, response.statusCode, endpoint);
    // TODO : need more enhancements
    RocketResponse rocketResponse = RocketResponse(result, response.statusCode);
    switch (response.statusCode) {
      case < 300 && >= 200:
        result = _handleTarget(inspect, result, target);
        if (model != null) {
          if (result is List?) {
            model.setMulti(result ?? []);
          } else {
            model.fromJson(result);
          }
          return model;
        }
        rocketResponse.update(result, response.statusCode);
        return rocketResponse;
      default:
        if (model != null) {
          model.setException(RocketException(
            response: result,
            statusCode: response.statusCode,
          ));
          return model;
        } else {
          rocketResponse.setException(RocketException(
            response: result,
            statusCode: response.statusCode,
          ));
          return rocketResponse;
        }
    }
  }

  _handleTarget(
      Function(dynamic data)? inspect, result, List<String>? targetData) {
    if (inspect != null) {
      result = inspect(result);
    } else if (targetData != null) {
      try {
        result = _getTarget(result, targetData);
      } catch (e) {
        log("Error in Target : $e, Try to use inspect instead");
      }
    }
    return result;
  }

  /// Sends an HTTP request to the specified `endpoint` using the specified HTTP `method`.
  ///
  /// If a `model` is provided, its `state` will be set to `RocketState.loading` before the request is sent.
  ///
  /// The `data` parameter contains the request body, which will be serialized to JSON before being sent.
  ///
  /// The `params` parameter contains the query parameters to be added to the URL.
  ///
  /// The `inspect` parameter can be used to inspect the raw response data before it is processed.
  ///
  /// The `targetData` parameter is a list of keys that will be used to extract a nested JSON object from the response data.
  ///
  /// If the request is successful and a `model` is provided, the response data will be processed using `_processModel<T>`.
  /// Otherwise, it will be processed using `_processData<T>`.
  ///
  /// If an error occurs, `_catchError` will be called to handle it.
  ///
  /// Returns a `Future` that resolves to the response data if model provided return it with data,Otherwise return json if can convert response, or string if can't convert to json response .
  /// Example Usage:
  /// ```dart
  /// void main() async {
  /// final rocket = Rocket('https://jsonplaceholder.typicode.com');

  /// final post = Post();

  /// await rocket.request('posts',
  ///     model: post);

  /// print(post.toJson());
  /// result = {
  ///   "userId": 1,
  ///   "id": 1,
  ///   "title":
  ///       "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
  ///   "body":
  ///       "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit "
  ///       "molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
  /// }
  /// }
  /// ```

  Future<RocketModel> request<T>(
    String endpoint, {
    RocketModel<T>? model,
    HttpMethods method = HttpMethods.get,
    RocketDataCallback inspect,
    List<String>? target,
    RocketOnError onError,
    Map<String, dynamic>? data,
    Map<String, dynamic>? params,
    RetryOptions retryOptions = const RetryOptions(),
  }) async {
    if (model != null) {
      model.state = RocketState.loading;
    }
    StreamedResponse? response;
    String mapToParams = Uri(queryParameters: params ?? {}).query;
    Uri url = Uri.parse("${this.url}/$endpoint?$mapToParams");
    Request request = Request(method.name, url);
    request.body = json.encode(data);
    request.headers.addAll(headers);
    final client = Client();
    final retryClient = RetryClient(client,
        retries: retryOptions.retries ??
            globalRetryOptions.retries ??
            RetryOptions.defaultRetries,
        when: retryOptions.retryWhen ??
            globalRetryOptions.retryWhen ??
            RetryOptions.defaultWhen,
        onRetry: retryOptions.onRetry ?? globalRetryOptions.onRetry,
        delay: retryOptions.delay ??
            globalRetryOptions.delay ??
            RetryOptions.defaultDelay);

    try {
      response = await retryClient.send(request);
      if (setCookies) {
        _updateCookie(response);
      }
      return _processData<T>(response,
          model: model, inspect: inspect, endpoint: endpoint, target: target);
    } catch (error, stackTrace) {
      log("$error $stackTrace");
      return _catchError(error, stackTrace, model: model);
    }
  }

  _getTarget(Map data, List target) {
    dynamic result = data;
    for (var key in target) {
      result = result[key];
    }
    return result;
  }

  _catchError(Object e, StackTrace stackTrace, {RocketModel? model}) async {
    if (model == null) {
      return Future.value(e);
    } else {
      model.setException(
          RocketException(exception: e.toString(), stackTrace: stackTrace));
      return Future.value(model);
    }
  }

  /// Sends a file or files to the specified endpoint and returns the response as a Future.
  ///
  /// The `endpoint` parameter is required and specifies the endpoint that the file(s) will be sent to.
  ///
  /// The `fields` parameter is optional and specifies any additional fields to be sent along with the file(s).
  ///
  /// The `files` parameter is optional and specifies the file(s) to be sent. The keys represent the form field names,
  /// and the values represent the file paths.
  ///
  /// The `id` parameter is optional and specifies an ID to be included in the URL. The default is an empty string.
  ///
  /// The `method` parameter is optional and specifies the HTTP method to use for sending the request. The default is `HttpMethods.post`.
  ///
  /// Returns a `Future` that resolves to the processed response data.
  ///
  /// May throw an exception if an error occurs during the HTTP request.
  ///
  /// Example Usage:
  /// ```
  /// final client = RocketClient();
  ///
  /// // Send a file to the "upload" endpoint
  /// final response = await client.sendFile("upload", files: {
  //// "file": "/path/to/my/file.jpg",
  /// });
  ///
  /// Send multiple files to the "upload" endpoint with additional fields and a PUT method
  /// final response = await client.sendFile("upload", method:HttpMethods.put, fields: {
  //// "name": "My File",
  //// "description": "This is a file",
  /// }, files: {
  //// "file1": "/path/to/my/file1.jpg",
  //// "file2": "/path/to/my/file2.jpg",
  /// });
  /// ```
  Future sendFile(
      String endpoint, Map<String, String>? fields, Map<String, String>? files,
      {String id = "", HttpMethods method = HttpMethods.post}) async {
    String end = method == HttpMethods.post ? id : "$id/";
    var request =
        MultipartRequest(method.name, Uri.parse("$url/$endpoint/$end"));
    files?.forEach((key, value) async {
      request.files.add(await MultipartFile.fromPath(key, value));
    });

    request.fields.addAll(fields!);
    request.headers.addAll(headers);

    var response = await request.send();
    switch (response.statusCode) {
      case < 300 && >= 200:
        var responseData = await response.stream.toBytes();
        var result = json.decode(utf8.decode(responseData));
        return result;
      default:
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        return responseString;
    }
  }

  void _updateCookie(StreamedResponse response) {
    String rawCookie = response.headers['set-cookie']!;
    int index = rawCookie.indexOf(';');
    headers['cookie'] =
        (index == -1) ? rawCookie : rawCookie.substring(0, index);
  }
}

class RocketResponse extends RocketModel {
  RocketResponse(this.response, this.kStatusCode);
  dynamic response;
  int kStatusCode;
  void update(dynamic resp, int statusCode) {
    kStatusCode = statusCode;
    response = resp;
  }

  @override
  get apiResponse => response;

  @override
  int get statusCode => kStatusCode;
}
