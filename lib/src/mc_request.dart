import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mvc_rocket/src/mc_constants.dart';

import 'mc_exception.dart';
import 'mc_model.dart';

class RocketRequest {
  final String url;
  final Map<String, String> headers;
  final bool setCookies;

  /// انشاء الطلب.
  ///
  /// [url]
  ///
  /// هو الرابط الخاص بالخادم بدون نقطة النهاية كمثال
  ///
  ///
  /// شكل صحيح
  ///
  /// www.test.com/api/
  ///
  ///
  /// شكل حاطئ
  ///
  /// www.test.com/api/users/
  ///
  ///
  /// [headers]
  ///
  /// متغيير اختياري
  ///
  /// [setCookies]
  ///
  /// Cookies تفعيل او الغاء حاصية الحفاظ على

  RocketRequest({
    required this.url,
    this.headers = const {},
    this.setCookies = false,
  });

  @protected
  Future<RocketModel> _processModel<T>(StreamedResponse response,
      {required RocketModel<T> model,
      Function(dynamic data)? inspect,
      List<String>? targetData,
      String? endpoint}) async {
    // TODO(M97chahboun) : Refactor conditions
    String respDecoded = utf8.decode(await response.stream.toBytes());
    switch (response.statusCode) {
      case < 300 && >= 200:
        var result = json.decode(respDecoded);
        result = _handleTarget(inspect, result, targetData);
        if (result is List?) {
          model.setMulti(result ?? []);
        } else {
          model.fromJson(result);
        }
      default:
        model.setException(RocketException(
          response: respDecoded,
          statusCode: response.statusCode,
        ));
        _onError(RocketException(
          response: respDecoded,
          statusCode: response.statusCode,
        ));
    }
    return model;
  }

  _processData<T>(StreamedResponse response,
      {Function(dynamic data)? inspect,
      List<String>? targetData,
      String? endpoint}) async {
    String respDecoded = utf8.decode(await response.stream.toBytes());
    switch (response.statusCode) {
      case < 300 && >= 200:
        var result = json.decode(respDecoded);
        result = _handleTarget(inspect, result, targetData);
        return result;
      default:
        _onError(RocketException(
          response: respDecoded,
          statusCode: response.statusCode,
        ));
        late dynamic result = respDecoded;
        try {
          result = json.decode(respDecoded);
        } catch (e) {
          result = respDecoded;
        }
        return result;
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

  static _onError(Object e) => log(e.toString());

  /// دالة خاصة لجلب البيانات على شكل (قاموس)
  ///
  /// Json=>(قاموس)
  ///
  ///
  /// عندما يكون (متعدد) صحيح هذا يعني أنك ستجلب بيانات على شكل (قاموس) داخل (مصفوفة)]
  ///
  ///
  /// [multi]=> (متعدد)
  ///
  ///
  /// [List]=>(قاموس)
  ///
  /// [inspect] => (،ارجاع القيمة المراد استخدامها ,json التنقيب داخل )

  Future request<T>(String endpoint,
      {RocketModel<T>? model,
      HttpMethods method = HttpMethods.get,
      Function(dynamic data)? inspect,
      List<String>? targetData,
      Map<String, dynamic>? data,
      Map<String, dynamic>? params}) async {
    if (model != null) {
      model.state = RocketState.loading;
    }
    StreamedResponse? response;
    String mapToParams = Uri(queryParameters: params ?? {}).query;
    Uri url = Uri.parse("${this.url}/$endpoint?$mapToParams");
    Request request = Request(method.name, url);
    request.body = json.encode(data);
    request.headers.addAll(headers);
    try {
      response = await request.send();
      if (setCookies) {
        _updateCookie(response);
      }
      if (model != null) {
        return _processModel<T>(response,
            model: model,
            inspect: inspect,
            endpoint: endpoint,
            targetData: targetData);
      } else {
        return _processData<T>(response,
            inspect: inspect, endpoint: endpoint, targetData: targetData);
      }
    } catch (error, stackTrace) {
      return _catchError(error, stackTrace, response, model: model);
    }
  }

  _getTarget(Map data, List target) {
    for (var key in target) {
      data = data[key];
    }
    return data;
  }

  _catchError(Object e, StackTrace stackTrace, StreamedResponse? response,
      {RocketModel? model}) async {
    String? body;
    int? statusCode;
    if (response != null) {
      var decodeResponse = json.decode(await response.stream.bytesToString());
      body = decodeResponse;
      statusCode = response.statusCode;
    }
    if (model == null) {
      _onError(e);
      return Future.value(e);
    } else {
      model.setException(RocketException(
          response: body!,
          statusCode: statusCode!,
          exception: e.toString(),
          stackTrace: stackTrace));
      return Future.value(model);
    }
  }

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
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseData = await response.stream.toBytes();
      var result = json.decode(utf8.decode(responseData));
      return result;
    } else {
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
