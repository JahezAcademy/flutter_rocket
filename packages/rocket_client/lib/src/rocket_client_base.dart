import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:rocket_client/src/retry_options.dart';
import 'package:rocket_model/rocket_model.dart';

import 'package:rocket_cache/rocket_cache.dart';
import 'enums.dart';

// ---------------------------------------------------------------------------
// Typedefs
// ---------------------------------------------------------------------------

/// Transforms raw response data before it is mapped onto a [RocketModel].
///
/// Return the value you want to use as the final data (e.g. extract a nested
/// key from the JSON map).
typedef RocketDataCallback = dynamic Function(dynamic data)?;

/// Called when the server returns a non-2xx status code.
typedef RocketOnError = void Function(dynamic response, int statusCode)?;

/// Intercepts an outgoing [Request] before it is sent.
///
/// You can add headers, modify the body, change the URL, etc.
/// Must return the (possibly mutated) [Request].
typedef RequestInterceptor = FutureOr<Request> Function(Request request);

/// Intercepts the [RocketModel] result after a successful response.
///
/// Use this to refresh tokens, log, or transform the result globally.
/// Must return the (possibly mutated) [RocketModel].
typedef ResponseInterceptor = FutureOr<RocketModel> Function(
    RocketModel result);

// ---------------------------------------------------------------------------
// RocketClient
// ---------------------------------------------------------------------------

class RocketClient {
  final String url;
  final Map<String, String> headers;
  final bool setCookies;
  final void Function(dynamic data, int statusCode, String? endpoint)?
      onResponse;
  final RetryOptions globalRetryOptions;
  final Client? _client;
  final Duration? globalCacheDuration;
  final bool globalCache;

  /// Called before every request is sent. Use to inject auth headers, etc.
  final RequestInterceptor? beforeRequest;

  /// Called after every successful response. Use to refresh tokens, log, etc.
  final ResponseInterceptor? afterResponse;

  RocketClient({
    required this.url,
    Map<String, String>? headers,
    this.setCookies = false,
    this.globalRetryOptions = const RetryOptions(),
    this.onResponse,
    this.beforeRequest,
    this.afterResponse,
    this.globalCacheDuration,
    this.globalCache = false,
    Client? client,
  })  : _client = client,
        headers = headers ?? {};

  // -------------------------------------------------------------------------
  // Public API
  // -------------------------------------------------------------------------

  /// Sends an HTTP request to [endpoint] using the given HTTP [method].
  ///
  /// - [model]         : If provided, its state transitions to [RocketState.loading]
  ///                     before the request and is populated with the response data.
  /// - [method]        : HTTP verb. Defaults to [HttpMethods.get].
  /// - [data]          : Request body serialised to JSON.
  /// - [params]        : Query parameters appended to the URL.
  /// - [inspect]       : Transform the raw response value before model mapping.
  /// - [target]        : Path of keys used to extract a nested JSON value
  ///                     (e.g. `['data', 'items']`). Ignored when [inspect] is set.
  /// - [cache]         : Cache the response for this specific request.
  /// - [cacheDuration] : How long the cache entry is considered fresh.
  /// - [retryOptions]  : Per-request retry configuration. `null` falls back to
  ///                     [globalRetryOptions].
  /// - [refresh]       : When `true`, clears the model's list and bypasses cache.
  ///
  /// Returns the populated [model] when provided, otherwise a [RocketResponse]
  /// containing the raw JSON (or raw string if JSON decoding fails).
  ///
  /// Example:
  /// ```dart
  /// final post = Post();
  /// await client.request('posts/1', model: post);
  /// print(post.toJson());
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
    bool cache = false,
    @Deprecated('Cache key is now generated automatically') String? cacheKey,
    Duration? cacheDuration,
    RetryOptions? retryOptions,
    bool refresh = false,
  }) async {
    if (model != null) {
      model.state = RocketState.loading;
    }

    // ── Cache read ──────────────────────────────────────────────────────────
    if ((globalCache || cache) && !refresh && method == HttpMethods.get) {
      cacheKey =
          Uri.parse(endpoint).replace(queryParameters: params).toString();

      final cachedData = await RocketCache.load(
        cacheKey,
        expiration: globalCacheDuration ?? cacheDuration,
      );

      if (cachedData != null) {
        return _handleResponseData<T>(
          cachedData,
          200,
          model: model,
          inspect: inspect,
          target: target,
          endpoint: endpoint,
        );
      }
    }

    if (refresh) {
      model?.all?.clear();
    }

    // ── Build URL ───────────────────────────────────────────────────────────
    final String mapToParams = Uri(queryParameters: params ?? {}).query;
    final String baseUrl = url.endsWith('/') ? url : '$url/';
    final String cleanEndpoint =
        endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    final Uri fullUrl = Uri.parse(
      '$baseUrl$cleanEndpoint${mapToParams.isNotEmpty ? '?$mapToParams' : ''}',
    );

    // ── Build Request ───────────────────────────────────────────────────────
    Request httpRequest = Request(method.name, fullUrl);
    if (data != null) httpRequest.body = json.encode(data);
    httpRequest.headers.addAll(headers);

    httpRequest = await beforeRequest?.call(httpRequest) ?? httpRequest;

    // ── Retry client ────────────────────────────────────────────────────────
    final effective = retryOptions ?? globalRetryOptions;
    final client = _client ?? Client();
    final retryClient = RetryClient(
      client,
      retries: effective.retries ?? RetryOptions.defaultRetries,
      when: effective.retryWhen ?? RetryOptions.defaultWhen,
      onRetry: effective.onRetry,
      delay: effective.delay ?? RetryOptions.defaultDelay,
    );

    // ── Send ────────────────────────────────────────────────────────────────
    try {
      final response = await retryClient.send(httpRequest);

      if (setCookies) {
        _updateCookie(response);
      }

      RocketModel result = await _processData<T>(
        response,
        model: model,
        inspect: inspect,
        endpoint: endpoint,
        target: target,
        cacheKey: cacheKey,
      );

      result = await afterResponse?.call(result) ?? result;

      return result;
    } catch (error, stackTrace) {
      log('$error $stackTrace');
      return _catchError(error, stackTrace, model: model);
    }
  }

  /// Sends a multipart request (file upload) to [endpoint].
  ///
  /// - [fields] : Additional form fields.
  /// - [files]  : Map of field name → file path.
  /// - [id]     : Optional ID appended to the URL.
  /// - [method] : HTTP verb. Defaults to [HttpMethods.post].
  ///
  /// Returns the decoded JSON response on success, or the raw response string
  /// on failure.
  ///
  /// Example:
  /// ```dart
  /// await client.sendFile(
  ///   'upload',
  ///   fields: {'name': 'profile'},
  ///   files:  {'avatar': '/path/to/image.jpg'},
  /// );
  /// ```
  Future<dynamic> sendFile(
    String endpoint, {
    Map<String, String>? fields,
    Map<String, String>? files,
    String id = '',
    HttpMethods method = HttpMethods.post,
  }) async {
    final String end = method == HttpMethods.post ? id : '$id/';
    final request = MultipartRequest(
      method.name,
      Uri.parse('$url/$endpoint/$end'),
    );

    if (files != null) {
      for (final entry in files.entries) {
        request.files.add(await MultipartFile.fromPath(entry.key, entry.value));
      }
    }

    if (fields != null) request.fields.addAll(fields);
    request.headers.addAll(headers);

    final response = await request.send();
    final responseBytes = await response.stream.toBytes();

    switch (response.statusCode) {
      case >= 200 && < 300:
        return json.decode(utf8.decode(responseBytes));
      default:
        return String.fromCharCodes(responseBytes);
    }
  }

  /// Simulates a network response without making a real HTTP request.
  ///
  /// Useful for testing UI state transitions. Waits [responseDuration] before
  /// populating [model] with [data].
  Future<void> requestSimulation<T>(
    String endpoint, {
    required RocketModel<T> model,
    HttpMethods method = HttpMethods.get,
    RocketDataCallback inspect,
    List<String>? target,
    dynamic data,
    Duration responseDuration = const Duration(seconds: 2),
  }) async {
    final result = _handleTarget(inspect, data, target);
    model.state = RocketState.loading;
    await Future.delayed(responseDuration);

    if (result is List) {
      model.setMulti(result);
    } else if (result is Map<String, dynamic>) {
      model.fromJson(result);
    } else {
      throw ArgumentError.value(
        result,
        'data',
        'Expected a List or Map<String, dynamic>',
      );
    }
  }

  // -------------------------------------------------------------------------
  // Private helpers
  // -------------------------------------------------------------------------

  Future<RocketModel> _processData<T>(
    StreamedResponse response, {
    RocketModel<T>? model,
    RocketDataCallback inspect,
    List<String>? target,
    String? endpoint,
    String? cacheKey,
  }) async {
    final String respDecoded = utf8.decode(await response.stream.toBytes());
    dynamic result;
    try {
      result = json.decode(respDecoded);
    } catch (_) {
      result = respDecoded;
    }

    if (cacheKey != null &&
        response.statusCode >= 200 &&
        response.statusCode < 300) {
      await RocketCache.save(cacheKey, result);
    }

    return _handleResponseData<T>(
      result,
      response.statusCode,
      model: model,
      inspect: inspect,
      target: target,
      endpoint: endpoint,
    );
  }

  RocketModel _handleResponseData<T>(
    dynamic result,
    int statusCode, {
    RocketModel<T>? model,
    RocketDataCallback inspect,
    List<String>? target,
    String? endpoint,
  }) {
    onResponse?.call(result, statusCode, endpoint);

    final RocketResponse rocketResponse = RocketResponse(result, statusCode);

    if (statusCode >= 200 && statusCode < 300) {
      final dynamic shaped = _handleTarget(inspect, result, target);

      if (model != null) {
        if (shaped is List?) {
          model.setMulti(shaped ?? []);
        } else {
          model.fromJson(shaped);
        }
        return model;
      }

      rocketResponse.update(shaped, statusCode);
      return rocketResponse;
    } else {
      final exception =
          RocketException(response: result, statusCode: statusCode);

      if (model != null) {
        model.setException(exception);
        return model;
      }

      rocketResponse.setException(exception);
      return rocketResponse;
    }
  }

  dynamic _handleTarget(
    dynamic Function(dynamic data)? inspect,
    dynamic result,
    List<String>? targetData,
  ) {
    if (inspect != null) {
      return inspect(result);
    } else if (targetData != null) {
      try {
        return _getTarget(result as Map, targetData);
      } catch (e) {
        log('Error in target: $e — use inspect instead');
      }
    }
    return result;
  }

  dynamic _getTarget(Map<dynamic, dynamic> data, List<String> target) {
    dynamic result = data;
    for (final key in target) {
      result = result[key];
    }
    return result;
  }

  Future<RocketModel> _catchError(
    Object error,
    StackTrace stackTrace, {
    RocketModel? model,
  }) async {
    final exception = RocketException(
      exception: error.toString(),
      stackTrace: stackTrace,
    );

    if (model != null) {
      model.setException(exception);
      return model;
    }

    return RocketResponse(error, 0)..setException(exception);
  }

  /// Updates the `cookie` header from the `set-cookie` header in [response].
  ///
  /// Only used when [setCookies] is `true`.
  void _updateCookie(StreamedResponse response) {
    final String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      final int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}

// ---------------------------------------------------------------------------
// RocketResponse
// ---------------------------------------------------------------------------

/// A lightweight [RocketModel] used when no typed model is provided to
/// [RocketClient.request].
class RocketResponse extends RocketModel {
  RocketResponse(this._response, this._statusCode);

  dynamic _response;
  int _statusCode;

  void update(dynamic response, int statusCode) {
    _response = response;
    _statusCode = statusCode;
  }

  @override
  dynamic get apiResponse => _response;

  @override
  int get statusCode => _statusCode;
}
