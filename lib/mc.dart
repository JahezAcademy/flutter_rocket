/// mc package for state management & request
/// based on MVCR
/// Model
/// View
/// Controller
/// Request
/// Powerful & easy
/// developed with ❤️ by Mohammed CHAHBOUN

library mc;

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class McRequest extends McModel {
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
  /// شطل صحيح
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
  McRequest(
      {required this.url,
      this.headers = const {},
      this.setCookies = false,
      this.debugging = true});

  @protected
  checkerJson(http.Response response,
      {bool? complex, Function(dynamic data)? inspect, String? endpoint}) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      if (complex!) {
        data = inspect!(data);
      }
      return data;
    } else {
      getDebugging(response, endpoint);
      return json.decode(utf8.decode(response.bodyBytes));
    }
  }

  getDebugging(http.Response response, String? endpoint) {
    if (debugging) {
      print("\x1B[38;5;2m ########## mc package ########## \x1B[0m");
      print("\x1B[38;5;2m [Url] => ${url + "/" + endpoint!} \x1B[0m");
      print("\x1B[38;5;2m [Response] => " + response.body + " \x1B[0m");
      print(
          "\x1B[38;5;2m [${response.statusCode}] => ${msgByStatusCode(response.statusCode)} \x1B[0m");
      print("\x1B[38;5;2m ################################ \x1B[0m");
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
        return "success";
    }
  }

  @protected
  dynamic checkerObj<T>(http.Response response, McModel<T> model,
      {bool? multi,
      bool? complex,
      Function(dynamic data)? inspect,
      String? endpoint}) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      model.existData = true;
      if (multi!) {
        var result = json.decode(utf8.decode(response.bodyBytes));
        if (complex!) {
          result = inspect!(result);
          model.setMulti(result);
        } else {
          model.setMulti(result);
        }
        return model;
      } else {
        var result = json.decode(utf8.decode(response.bodyBytes));
        if (!complex!) {
          model.fromJson(result);
          return model;
        } else {
          result = inspect!(result);
          model.fromJson(result);
          return model;
        }
      }
    } else {
      model.load(false);
      getDebugging(response, endpoint);
      throw Exception('Failed to load Data');
    }
  }

  @protected
  String mapToString(Map mp) {
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
  /// [inspect] => List<Map>
  Future getJsonData(String endpoint,
      {Map<String, dynamic>? params,
      bool complex = false,
      Function(Object error)? onError,
      Function(dynamic data)? inspect}) async {
    String srch = params != null ? mapToString(params) : "";
    Uri url = Uri.parse(this.url + "/" + endpoint + '?' + srch);
    try {
      http.Response response = await http.get(url, headers: headers);
      return checkerJson(response,
          complex: complex, inspect: inspect, endpoint: endpoint);
    } catch (e) {
      onError!(e);
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
  /// [inspect] => List<Map>

  Future getObjData<T>(String endpoint, McModel<T> model,
      {Map<String, dynamic>? params,
      bool multi = false,
      bool complex = false,
      Function(dynamic data)? inspect}) async {
    model.load(true);
    String srch = params != null ? mapToString(params) : "";
    Uri url = Uri.parse(this.url + "/" + endpoint + '?' + srch);
    http.Response? response;
    try {
      http.Response response = await http
          .get(url, headers: headers)
          .whenComplete(() => model.load(false));

      model.setFailed(false);
      return checkerObj<T>(response, model,
          multi: multi, complex: complex, inspect: inspect, endpoint: endpoint);
    } catch (e, s) {
      model.setException(e.toString(), s, response);
      model.setFailed(true);
    }
  }

  /// دالة خاصة بتعديل البيانات على شكل بالنموذج الذي تم تمريره مع الدالة
  ///
  /// [model]=>(النموذج)
  ///
  /// [inspect] => List<Map>

  Future<McModel> putObjData<T>(int id, String endpoint, McModel<T> model,
      {bool complex = false,
      bool multi = false,
      Function(dynamic data)? inspect}) async {
    model.load(true);
    Uri url = Uri.parse(this.url + "/" + endpoint + "/" + id.toString() + "/");
    http.Response? response;
    try {
      response = await http
          .put(url, body: json.encode(model.toJson()), headers: headers)
          .whenComplete(() => model.load(false));
      model.setFailed(false);
      return checkerObj<T>(response, model,
          complex: complex, inspect: inspect, multi: multi, endpoint: endpoint);
    } catch (e, s) {
      model.setException(e.toString(), s, response);
      model.setFailed(true);
      return Future.value(model);
    }
  }

  /// دالة خاصة لتعديل البيانات بالقاموس الذي تم تمريره مع الدالة
  ///
  /// [data]=>(قاموس)
  ///
  /// [inspect] => List<Map>

  Future putJsonData(int id, String endpoint, Map<String, dynamic> data,
      {bool complex = false,
      Function(dynamic data)? inspect,
      Function(Object error)? onError}) async {
    Uri url = Uri.parse(this.url + "/" + endpoint + "/" + id.toString() + "/");
    try {
      http.Response response =
          await http.put(url, body: json.encode(data), headers: headers);
      return checkerJson(response,
          complex: complex, inspect: inspect, endpoint: endpoint);
    } catch (e) {
      onError!(e);
    }
  }

  /// دالة خاصة بارسال البيانات على شكل النموذج الذي تم تمريره مع الدالة
  ///
  /// [model]=>(النموذج)
  ///
  /// [inspect] => List<Map>

  Future<McModel> postObjData<T>(String endPoint,
      {McModel<T>? model,
      bool complex = false,
      bool multi = false,
      Function(dynamic data)? inspect,
      Map<String, dynamic>? data,
      Map<String, dynamic>? params}) async {
    model!.load(true);
    String srch = params != null ? mapToString(params) : "";
    Uri url = Uri.parse(this.url + "/" + endPoint + "?" + srch);
    http.Response? response;
    try {
      response = await http
          .post(url, headers: headers, body: json.encode(data))
          .whenComplete(() => model.load(false));
      if (setCookies) {
        updateCookie(response);
      }
      model.setFailed(false);
      return checkerObj<T>(response, model,
          complex: complex, inspect: inspect, multi: multi, endpoint: endPoint);
    } catch (e, s) {
      model.setException(e.toString(), s, response);
      model.setFailed(true);
      return Future.value(model);
    }
  }

  /// دالة خاصة بارسال البيانات على شكل قاموس الذي تم تمريره مع الدالة
  ///
  /// Json=>(قاموس)
  ///
  /// [inspect] => List<Map>

  Future postJsonData(String endPoint,
      {Map<String, dynamic>? data,
      bool complex = false,
      Function(dynamic data)? inspect,
      Function(Object error)? onError,
      Map<String, dynamic>? params}) async {
    String srch = params != null ? mapToString(params) : "";
    Uri url = Uri.parse(this.url + "/" + endPoint + "?" + srch);
    try {
      http.Response response =
          await http.post(url, body: json.encode(data), headers: headers);
      if (setCookies) {
        updateCookie(response);
      }
      return checkerJson(response,
          complex: complex, inspect: inspect, endpoint: endPoint);
    } catch (e) {
      onError!(e);
    }
  }

  /// دالة خاصة بحذف البيانات عن طريق ر.م الخاص بهم
  ///
  /// [id]=>(ر.م)
  ///
  /// [inspect] => List<Map>
  ///
  Future delJsonData(int id, String endpoint,
      {Function(Object error)? onError}) async {
    Uri url = Uri.parse(this.url + "/" + endpoint + "/" + id.toString() + "/");
    try {
      http.Response response = await http.delete(url, headers: headers);
      return response.body;
    } catch (e) {
      onError!(e);
    }
  }

  Future sendFile(
      String endpoint, Map<String, String>? fields, Map<String, String>? files,
      {String id = "", String method = "POST"}) async {
    String end = method == "POST" ? '$id' : "$id/";
    var request =
        http.MultipartRequest(method, Uri.parse("$url/$endpoint/$end"));

    files?.forEach((key, value) async {
      request.files.add(await http.MultipartFile.fromPath(key, value));
    });

    /// request.files.addAll(files!.map((key, value) async {
    ///   return await http.MultipartFile.fromPath(key, value))
    /// });
    request.fields.addAll(fields!);
    request.headers.addAll(this.headers);

    var response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseData = await response.stream.toBytes();

      ///var responseString = String.fromCharCodes(responseData);
      var result = json.decode(utf8.decode(responseData));
      return result;
    } else {
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      return responseString;
    }
  }

  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie']!;
    int index = rawCookie.indexOf(';');
    headers['cookie'] =
        (index == -1) ? rawCookie : rawCookie.substring(0, index);
  }
}

/// يجب ان ترث النماذج المستخدمة من هذا الكائن
abstract class McModel<T> extends ChangeNotifier {
  bool loading = false;
  bool loadingChecker = false;
  List<T>? multi;
  bool failed = false;
  bool existData = false;
  late String exception;

  /// تفعيل و الغاء جاري التحميل
  void load(bool t) {
    loading = loadingChecker ? false : t;
    notifyListeners();
  }

  /// التقاط الخطأ
  void setException(String _exception, StackTrace t, http.Response? response) {
    exception = _exception;
    notifyListeners();
  }

  void loadingChecking(bool value) {
    loadingChecker = value;
    notifyListeners();
  }

  bool hasListener() {
    return super.hasListeners;
  }

  ///في حالة وجود خطأ
  void setFailed(bool state) {
    failed = state;
    notifyListeners();
  }

  ///حذف النموذج من قائمة النماذج
  void delItem(int index) {
    multi!.removeAt(index);
    notifyListeners();
  }

  /// ملئ النماذج من البيانات القادمة من الخادم
  void setMulti(List data) {
    notifyListeners();
  }

  /// من البيانات القادمة من الخادم الى نماذج
  void fromJson(Map<String, dynamic>? json) {
    notifyListeners();
  }

  ///json من النماذج الى بيانات
  Map<String, dynamic> toJson() {
    return {};
  }

  ///التحكم في اعادة البناء عن طريق تفعيل جاري التحميل و الغاءه
  void rebuild() {
    load(true);
    load(false);
  }
}

/// call طريقة استدعاء دالة

enum CallType {
  callAsStream,

  /// يتم استدعاء الدالة يشكل متكرر
  callAsFuture,

  /// يتم استدعاء الدالة مرة واحدة
  callIfModelEmpty,

  /// يتم استدعاء الدالة عندما يكون النموذج فارغ
}

class McView extends AnimatedWidget {
  /// [McView]
  ///
  /// انشاء البناء الخاص باعادة بناء المحتويات الخاصة به.
  ///
  ///
  ///[model]
  ///
  ///النموذج الذي يحتوي على البيانات المراد تجديدها
  ///
  ///
  ///[builder]
  ///
  ///البناء دالة ترجع المحتويات المراد اعادة بناءها لتغيير قيمها
  ///
  ///
  ///[loader]
  ///
  ///الجزء الخاص بانتظار تحميل البيانات و هو اختياري
  ///
  ///[call]
  ///
  ///الدالة الخاصة بطلب البيانات من لخادم
  ///
  ///
  ///[callType]
  ///
  ///طريقة استدعاء الدالة
  ///
  ///[secondsOfStream]
  ///
  ///يمكنك تحديد عدد الثواني من اجل تجديد البيانات callAsStream في حالة اختيار
  ///
  ///[retryText]
  ///
  ///النص الذي سيظهر في الور في حالة وجود خطأ
  ///
  ///[styleButton]
  ///
  ///تصميم الزر يمكنك التحكم من حلاله في الألوان ...
  ///
  ///[showExceptionDetails]
  ///
  ///تفعيل او الغاء ظهور تفاصيل الخطأ
  ///
  McView(
      {Key? key,
      required this.model,
      required this.builder,
      this.call = _myDefaultFunc,
      this.callType = CallType.callAsFuture,
      this.secondsOfStream = 1,
      this.child,
      this.loader,
      this.retryText = "Failed, retry",
      this.styleButton,
      this.showExceptionDetails = false})
      : super(key: key, listenable: model) {
    /// call التحقق من طريقة الاستدعاء لدالة
    switch (callType) {
      case CallType.callAsFuture:
        call();
        break;
      case CallType.callIfModelEmpty:
        if (!model.existData) {
          call();
        }
        break;
      case CallType.callAsStream:
        call();
        Timer.periodic(Duration(seconds: secondsOfStream), (timer) {
          model.loadingChecking(true);
          call();
          if (!model.hasListener()) timer.cancel();
        });
        break;
    }
  }

  static _myDefaultFunc() {}
  final TransitionBuilder builder;
  final dynamic Function() call;
  final CallType callType;
  final int secondsOfStream;
  final Widget? child;
  final Widget? loader;
  final McModel model;
  final String retryText;
  final ButtonStyle? styleButton;
  final bool showExceptionDetails;

  @override
  Widget build(BuildContext context) {
    if (model.failed) {
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.2,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  child: Text(retryText),
                  style: styleButton,
                  onPressed: () {
                    model.setFailed(false);
                    model.load(true);
                    call();
                  }),
              showExceptionDetails
                  ? ElevatedButton(
                      child: Text("show Details"),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(model.exception.split(":")[0]),
                                content: Text(model.exception),
                              );
                            });
                      })
                  : const SizedBox(),
            ],
          ),
        ),
      );
    } else {
      return model.loading
          ? Center(child: loader ?? CircularProgressIndicator())
          : builder(context, child);
    }
  }
}

/// حاص بتخزين النماذج المستحدمة و الحفاظ على البياتات
class McController {
  static final McController _controller = McController._internal();
  Map<String, dynamic> models = {};

  /// اضافة تموذج جديد
  T add<T>(String key, T model) {
    if (key.contains('!')) {
      if (!models.containsKey(key.substring(1))) {
        models[key.substring(1)] = model;
        return model;
      } else {
        return models[key.substring(1)];
      }
    } else {
      models[key] = model;
      return model;
    }
  }

  /// الوصول لنموذج
  T get<T>(String key) {
    return models[key];
  }

  /// حذف النموذح
  void remove(String key) {
    models.remove(key);
  }

  factory McController([String? key, McModel? model]) {
    if (key != null && model != null) {
      _controller.add(key, model);
    }
    return _controller;
  }

  McController._internal();
}

/// Extensions helper

extension Mcless on StatelessWidget {
  McController get mc => McController();
}

extension Mcful on State {
  McController get mc => McController();
}
