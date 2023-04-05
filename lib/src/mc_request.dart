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
  final bool debugging;

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
  ///
  /// [debugging]
  ///
  /// console تفعيل او الغاء ظهور المشاكل في
  RocketRequest(
      {required this.url,
      this.headers = const {},
      this.setCookies = false,
      this.debugging = true});

  _getDebugging(StreamedResponse response, String? endpoint) {
    if (debugging) {
      log("\x1B[38;5;2m ########## mc package ########## \x1B[0m");
      log("\x1B[38;5;2m [Url] => ${"$url/${endpoint!}"} \x1B[0m");
      log("\x1B[38;5;2m [Response] => ${response.toString()} \x1B[0m");
      log("\x1B[38;5;2m [${response.statusCode}] => ${msgByStatusCode(response.statusCode)} \x1B[0m");
      log("\x1B[38;5;2m ################################ \x1B[0m");
    }
  }

  String msgByStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return "the request entity sent by your application could not be understood by the server due to malformed syntax (e.g. invalid payload, data type mismatch)";
      case 401:
        return "there is a problem with the credentials provided by your application. This code indicates that your application tried to operate on a protected resource without providing the proper authorization. It may have provided the wrong credentials or none at all";
      case 403:
        return "your application is not authorized to access the requested resource, or when your application is being rate limited";
      case 404:
        return "the resource requested by your application does not exist";
      case 405:
        return "the HTTP method used by your application is not allowed for the resource";
      case 406:
        return "the resource requested by your application is not capable of generating response entities that are compliant the Accept headers sent";
      case 408:
        return "your application did not produce a request within the time that the server was prepared to wait";
      case 409:
        return "the request sent by your application could not be completed due to a conflict with the current state of the resource";
      case 415:
        return "the request entity sent by your application is in a format not supported by the requested resource for the requested method";
      case 429:
        return "your application has made too many calls and has exceeded the rate limit for this service";
      case 500:
        return "the server encountered an unexpected condition which prevented it from fulfilling the request sent by your application";
      case 502:
        return "the server encountered an unexpected condition which prevented it from fulfilling the request sent by your application";
      case 503:
        return "the server is currently unable to handle the request sent by your application due to a temporary overloading or maintenance of the server";
      case 504:
        return "the server, while acting as a gateway or proxy, did not get a response in time from the upstream server that it needed in order to complete the API call.";
      default:
        return "unknown";
    }
  }

  @protected
  dynamic _processData<T>(StreamedResponse response,
      {RocketModel<T>? model,
      Function(dynamic data)? inspect,
      String? endpoint}) async {
    if (response.statusCode < 300 && response.statusCode >= 200) {
      var result = json.decode(utf8.decode(await response.stream.toBytes()));
      if (inspect != null) {
        result = inspect(result);
      }
      if (model != null) {
        if (result is List?) {
          model.setMulti(result ?? []);
          return model.all;
        } else {
          model.fromJson(result);
          return model;
        }
      } else {
        return result;
      }
    } else {
      model!.setException(RocketException(
        response: utf8.decode(await response.stream.toBytes()),
        statusCode: response.statusCode,
      ));
      _getDebugging(response, endpoint);
    }
  }

  static _onError(Object e) => log(e.toString());

  //DONE: rename to maptoParams & inject into Map
  @protected
  String _mapToString(Map mp) {
    String result = "";
    mp.forEach((key, value) {
      String and = mp.keys.last != key ? "&" : "";
      result = "${result + key}=$value$and";
    });
    return result;
  }

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
      Map<String, dynamic>? data,
      Map<String, dynamic>? params}) async {
    if (model != null) {
      model.state = RocketState.loading;
    }
    StreamedResponse? response;
    String mapToParams = params != null ? _mapToString(params) : "";
    Uri url = Uri.parse("${this.url}/$endpoint?$mapToParams");
    Request request = Request(method.name, url);
    request.body = json.encode(data);
    request.headers.addAll(headers);
    try {
      response = await request.send();
      if (setCookies) {
        _updateCookie(response);
      }
      return _processData<T>(response,
          model: model, inspect: inspect, endpoint: endpoint);
    } catch (error, stackTrace) {
      return _catchError(error, stackTrace, response, model: model);
    }
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
