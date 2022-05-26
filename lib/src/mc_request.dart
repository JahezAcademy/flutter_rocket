import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mvc_rocket/src/mc_constants.dart';
import 'mc_model.dart';
import 'mc_exception.dart';

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

  @protected
  dynamic _jsonData(Response response,
      {Function(dynamic data)? inspect, String? endpoint}) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      if (inspect != null) {
        data = inspect(data);
      }
      return data;
    } else {
      _getDebugging(response, endpoint);
      try {
        return json.decode(utf8.decode(response.bodyBytes));
      } catch (e) {
        return response.body;
      }
    }
  }

  _getDebugging(Response response, String? endpoint) {
    if (debugging) {
      log("\x1B[38;5;2m ########## mc package ########## \x1B[0m");
      log("\x1B[38;5;2m [Url] => ${url + "/" + endpoint!} \x1B[0m");
      log("\x1B[38;5;2m [Response] => " + response.body + " \x1B[0m");
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
  dynamic _objData<T>(Response response, RocketModel<T> model,
      {bool? multi, Function(dynamic data)? inspect, String? endpoint}) {
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      if (multi!) {
        var result = json.decode(utf8.decode(response.bodyBytes));
        if (inspect != null) {
          result = inspect(result);
        }
        model.setMulti(result ?? []);

        return model.multi;
      } else {
        var result = json.decode(utf8.decode(response.bodyBytes));
        if (inspect != null) {
          result = inspect(result);
        }
        model.fromJson(result);
        return model;
      }
    } else {
      model.state = RocketState.failed;
      _getDebugging(response, endpoint);
      throw Exception('Failed to load Data');
    }
  }

  static _onError(Object e) => print(e);

  //DONE: rename to maptoParams & inject into Map
  @protected
  String _mapToString(Map mp) {
    String result = "";
    mp.forEach((key, value) {
      String and = mp.keys.last != key ? "&" : "";
      result = result + key + "=" + value.toString() + and;
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
  Future getJsonData(String endpoint,
      {Map<String, dynamic>? params,
      bool complex = false,
      Function(Object error) onError = _onError,
      Function(dynamic data)? inspect}) async {
    String srch = params != null ? _mapToString(params) : "";
    Uri url = Uri.parse(this.url + "/" + endpoint + '?' + srch);
    try {
      Response response = await get(url, headers: headers);
      return _jsonData(response, inspect: inspect, endpoint: endpoint);
    } catch (e) {
      onError(e);
    }
  }

  /// دالة خاصة لجلب البيانات على شكل النموذج الذي تم تمريره مع الدالة
  ///
  /// [model]=>(النموذج)
  ///
  ///  عندما يكون (متعدد) صحيح هذا يعني أنك ستجد بيناتك في (مصفوفة) داخل (النموذج) الخاص بك على شكل نفس النموذج يمكنك الوصول لهذه البيانات عن طريق المتغير
  ///
  ///
  /// [multi]=>(متعدد)
  ///
  /// [List]=>(مصفوفة)
  ///
  /// [inspect] => (،ارجاع القيمة المراد استخدامها ,json التنقيب داخل )

  Future getObjData<T>(String endpoint, RocketModel<T> model,
      {Map<String, dynamic>? params,
      bool multi = false,
      Function(dynamic data)? inspect}) async {
    String srch = params != null ? _mapToString(params) : "";
    Uri url = Uri.parse(this.url + "/" + endpoint + '?' + srch);
    model.state = RocketState.loading;
    Response? response;
    try {
      response = await get(url, headers: headers);
      return _objData<T>(response, model,
          multi: multi, inspect: inspect, endpoint: endpoint);
    } catch (error, stackTrace) {
      return _catchError(error, stackTrace, model, response);
    }
  }

  /// دالة خاصة بتعديل البيانات على شكل بالنموذج الذي تم تمريره مع الدالة
  ///
  /// [model]=>(النموذج)
  ///
  /// [inspect] => (،ارجاع القيمة المراد استخدامها ,json التنقيب داخل )

  Future<RocketModel> putObjData<T>(
      int id, String endpoint, RocketModel<T> model,
      {bool multi = false, Function(dynamic data)? inspect}) async {
    model.state = RocketState.loading;
    Uri url = Uri.parse(this.url + "/" + endpoint + "/" + id.toString() + "/");
    Response? response;
    try {
      response =
          await put(url, body: json.encode(model.toJson()), headers: headers);
      return _objData<T>(response, model,
          inspect: inspect, multi: multi, endpoint: endpoint);
    } catch (error, stackTrace) {
      return _catchError(error, stackTrace, model, response);
    }
  }

  _catchError(
      Object e, StackTrace stackTrace, RocketModel model, Response? response) {
    String? body;
    int? statusCode;
    if (response != null) {
      body = response.body;
      statusCode = response.statusCode;
    }
    model.setException(RocketException(
        response: body!,
        statusCode: statusCode!,
        exception: e.toString(),
        stackTrace: stackTrace));
    return Future.value(model);
  }

  /// دالة خاصة لتعديل البيانات بالقاموس الذي تم تمريره مع الدالة
  ///
  /// [data]=>(قاموس)
  ///
  /// [inspect] => (،ارجاع القيمة المراد استخدامها ,json التنقيب داخل )

  Future putJsonData(int id, String endpoint, Map<String, dynamic> data,
      {Function(dynamic data)? inspect,
      Function(Object error) onError = _onError}) async {
    Uri url = Uri.parse(this.url + "/" + endpoint + "/" + id.toString() + "/");
    try {
      Response response =
          await put(url, body: json.encode(data), headers: headers);
      return _jsonData(response, inspect: inspect, endpoint: endpoint);
    } catch (e) {
      onError(e);
    }
  }

  /// دالة خاصة بارسال البيانات على شكل النموذج الذي تم تمريره مع الدالة
  ///
  /// [model]=>(النموذج)
  ///
  /// [inspect] => (،ارجاع القيمة المراد استخدامها ,json التنقيب داخل )

  Future<RocketModel> postObjData<T>(String endPoint,
      {RocketModel<T>? model,
      bool multi = false,
      Function(dynamic data)? inspect,
      Map<String, dynamic>? data,
      Map<String, dynamic>? params}) async {
    model!.state = RocketState.loading;
    String srch = params != null ? _mapToString(params) : "";
    Uri url = Uri.parse(this.url + "/" + endPoint + "?" + srch);
    Response? response;
    try {
      response = await post(url, headers: headers, body: json.encode(data));
      if (setCookies) {
        _updateCookie(response);
      }
      return _objData<T>(response, model,
          inspect: inspect, multi: multi, endpoint: endPoint);
    } catch (error, stackTrace) {
      return _catchError(error, stackTrace, model, response);
    }
  }

  /// دالة خاصة بارسال البيانات على شكل قاموس الذي تم تمريره مع الدالة
  ///
  /// Json=>(قاموس)
  ///
  /// [inspect] => (،ارجاع القيمة المراد استخدامها ,json التنقيب داخل )

  Future postJsonData(String endPoint,
      {Map<String, dynamic>? data,
      Function(dynamic data)? inspect,
      Function(Object error) onError = _onError,
      Map<String, dynamic>? params}) async {
    String srch = params != null ? _mapToString(params) : "";
    Uri url = Uri.parse(this.url + "/" + endPoint + "?" + srch);
    try {
      Response response =
          await post(url, body: json.encode(data), headers: headers);
      if (setCookies) {
        _updateCookie(response);
      }
      return _jsonData(response, inspect: inspect, endpoint: endPoint);
    } catch (e) {
      onError(e);
    }
  }

  /// دالة خاصة بحذف البيانات عن طريق ر.م الخاص بهم
  ///
  /// [id]=>(ر.م)
  ///
  /// [inspect] => (،ارجاع القيمة المراد استخدامها ,json التنقيب داخل )
  ///
  Future delJsonData(int id, String endpoint,
      {Function(Object error) onError = _onError}) async {
    Uri url = Uri.parse(this.url + "/" + endpoint + "/" + id.toString() + "/");
    try {
      Response response = await delete(url, headers: headers);
      return response.body;
    } catch (e) {
      onError(e);
    }
  }

  //DONE: use enum instead of string for check http method
  Future sendFile(
      String endpoint, Map<String, String>? fields, Map<String, String>? files,
      {String id = "", HttpMethods method = HttpMethods.post}) async {
    String end = method == HttpMethods.post ? '$id' : "$id/";
    var request =
        MultipartRequest(method.name, Uri.parse("$url/$endpoint/$end"));
    files?.forEach((key, value) async {
      request.files.add(await MultipartFile.fromPath(key, value));
    });

    request.fields.addAll(fields!);
    request.headers.addAll(this.headers);

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

  void _updateCookie(Response response) {
    String rawCookie = response.headers['set-cookie']!;
    int index = rawCookie.indexOf(';');
    headers['cookie'] =
        (index == -1) ? rawCookie : rawCookie.substring(0, index);
  }
}
