library mc;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class McRequest extends McModel {
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
  /// [صحيح]
  ///
  /// www.test.com/api/
  ///
  ///
  /// [خطأ]
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
  McRequest(
      {required this.url, this.headers = const {}, this.setCookies = false});

  @protected
  checkerJson(http.Response response,
      {bool? complex, Function(dynamic data)? inspect}) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      if (complex!) {
        data = inspect!(data);
      }
      return data;
    } else {
      print("Response=>" + response.body);
      print({'Error': 'Failed to load Data: ${response.statusCode}'});
      return json.decode(utf8.decode(response.bodyBytes));
    }
  }

  @protected
  dynamic checkerObj<T>(http.Response response, McModel<T> model,
      {bool? multi, bool? complex, Function(dynamic data)? inspect}) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (multi!) {
        var result = json.decode(utf8.decode(response.bodyBytes));
        if (complex!) {
          result = inspect!(result);
          model.setMulti(result);
        } else {
          model.setMulti(result);
        }
        return model.multi;
      } else {
        var result = json.decode(utf8.decode(response.bodyBytes));
        //var result = decoded.length == 0 ? decoded : decoded[0];
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
      print(response.body);
      model.load(false);
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

  /// دالة خاصة لجلب البيانات على شكل [قاموس]
  ///
  ///[Json]=>[قاموس]
  ///
  ///
  ///عندما يكون [متعدد] صحيح هذا يعني أنك ستجلب بيانات على شكل [قاموس] داخل [مصفوفة]
  ///
  ///
  ///[multi]=>[متعدد]
  ///
  ///
  ///[List]=>[مصفوفة]
  ///
  ///[inspect] => List<Map>
  Future getJsonData(String endpoint,
      {Map<String, dynamic>? params,
      bool complex = false,
      Function(dynamic data)? inspect}) async {
    String srch = params != null ? mapToString(params) : "";
    Uri url = Uri.parse(this.url + "/" + endpoint + '?' + srch);

    http.Response response = await http.get(url, headers: headers);
    return checkerJson(response, complex: complex, inspect: inspect);
  }

  /// دالة خاصة لجلب البيانات على شكل النموذج الذي تم تمريره مع الدالة
  ///
  ///[model]=>[النموذج]
  ///
  ///  عندما يكون [متعدد] صحيح هذا يعني أنك ستجد بيناتك في [مصفوفة] داخل [النموذج] الخاص بك على شكل نفس النموذج يمكنك الوصول لهذه البيانات عن طريق المتغير
  ///
  ///[myModel.multi]
  ///
  ///[multi]=>[متعدد]
  ///
  ///[List]=>[مصفوفة]
  ///
  ///[inspect] => List<Map>

  Future getObjData<T>(String endpoint, McModel<T> model,
      {Map<String, dynamic>? params,
      bool multi = false,
      bool complex = false,
      Function(dynamic data)? inspect}) async {
    model.load(true);
    String srch = params != null ? mapToString(params) : "";
    Uri url = Uri.parse(this.url + "/" + endpoint + '?' + srch);
    try {
      http.Response response = await http
          .get(url, headers: headers)
          .whenComplete(() => model.load(false));
      model.setFailed(false);
      return checkerObj<T>(response, model,
          multi: multi, complex: complex, inspect: inspect);
    } catch (e) {
      model.setExcetion(e.toString());
      model.setFailed(true);
    }
  }

  /// دالة خاصة بتعديل البيانات على شكل بالنموذج الذي تم تمريره مع الدالة
  ///
  ///[model]=>[النموذج]
  ///
  ///[inspect] => List<Map>

  Future<McModel> putObjData<T>(int id, String endpoint, McModel<T> model,
      {bool complex = false,
      bool multi = false,
      Function(dynamic data)? inspect}) async {
    model.load(true);
    Uri url = Uri.parse(this.url + "/" + endpoint + "/" + id.toString() + "/");
    try {
      http.Response response = await http
          .put(url, body: json.encode(model.toJson()), headers: headers)
          .whenComplete(() => model.load(false));
      model.setFailed(false);
      return checkerObj<T>(response, model,
          complex: complex, inspect: inspect, multi: multi);
    } catch (e) {
      model.setExcetion(e.toString());
      model.setFailed(true);
      return Future.value(model);
    }
  }

  /// دالة خاصة لتعديل البيانات بالقاموس الذي تم تمريره مع الدالة
  ///
  ///[Json]=>[قاموس]
  ///
  ///[inspect] => List<Map>

  Future putJsonData(int id, String endpoint, Map<String, dynamic> data,
      {bool complex = false, Function(dynamic data)? inspect}) async {
    Uri url = Uri.parse(this.url + "/" + endpoint + "/" + id.toString() + "/");
    http.Response response =
        await http.put(url, body: json.encode(data), headers: headers);
    return checkerJson(response, complex: complex, inspect: inspect);
  }

  /// دالة خاصة بارسال البيانات على شكل النموذج الذي تم تمريره مع الدالة
  ///
  ///[model]=>[النموذج]
  ///
  ///[inspect] => List<Map>

  Future<McModel> postObjData<T>(String endPoint,
      {McModel<T>? model,
      bool complex = false,
      bool multi = false,
      Function(dynamic data)? inspect,
      Map<String, dynamic>? params}) async {
    model!.load(true);
    String srch = params != null ? mapToString(params) : "";
    Uri url = Uri.parse(this.url + "/" + endPoint + "?" + srch);
    try {
      http.Response response = await http
          .post(url, body: json.encode(model.toJson()), headers: headers)
          .whenComplete(() => model.load(false));
      if (setCookies) {
        updateCookie(response);
      }
      model.setFailed(false);
      return checkerObj<T>(response, model,
          complex: complex, inspect: inspect, multi: multi);
    } catch (e) {
      model.setExcetion(e.toString());
      model.setFailed(true);
      return Future.value(model);
    }
  }

  /// دالة خاصة بارسال البيانات على شكل قاموس الذي تم تمريره مع الدالة
  ///
  ///[Json]=>[قاموس]
  ///
  ///[inspect] => List<Map>

  Future postJsonData(String endPoint,
      {Map<String, dynamic>? data,
      bool complex = false,
      Function(dynamic data)? inspect,
      Map<String, dynamic>? params}) async {
    String srch = params != null ? mapToString(params) : "";
    Uri url = Uri.parse(this.url + "/" + endPoint + "?" + srch);
    http.Response response =
        await http.post(url, body: json.encode(data), headers: headers);
    if (setCookies) {
      updateCookie(response);
    }
    return checkerJson(response, complex: complex, inspect: inspect);
  }

  /// دالة خاصة بحذف البيانات عن طريق ر.م الخاص بهم
  ///
  ///[id]=>[ر.م]
  ///
  ///[inspect] => List<Map>
  ///
  Future delJsonData(int id, String endpoint) async {
    Uri url = Uri.parse(this.url + "/" + endpoint + "/" + id.toString() + "/");
    http.Response response = await http.delete(url, headers: headers);
    return response.body;
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
    // request.files.addAll(files!.map((key, value) async {
    //   return await http.MultipartFile.fromPath(key, value))
    // });
    request.fields.addAll(fields!);
    request.headers.addAll(this.headers);

    var response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseData = await response.stream.toBytes();
      //var responseString = String.fromCharCodes(responseData);
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

//يجب ان ترث النماذج المستخدمة من هذا الكائن
abstract class McModel<T> extends ChangeNotifier {
  bool loading = false;
  bool loadingChecker = false;
  List<T>? multi;
  bool failed = false;
  late String exception;

  // تفعيل و الغاء جاري التحميل
  void load(bool t) {
    loading = loadingChecker ? false : t;
    notifyListeners();
  }

  void setExcetion(String _exception) {
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

  void setFailed(bool state) {
    failed = state;
    notifyListeners();
  }

  //حذف النموذج من قائمة النماذج
  void delItem(int index) {
    multi!.removeAt(index);
    notifyListeners();
  }

  // ملئ النماذج من البيانات القادمة من الخادم
  void setMulti(List data) {
    notifyListeners();
  }

  // من البيانات القادمة من الخادم الى نماذج
  void fromJson(Map<String, dynamic>? json) {
    notifyListeners();
  }

  //json من النماذج الى بيانات
  Map<String, dynamic> toJson() {
    return {};
  }

  //التحكم في اعادة البناء عن طريق تفعيل جاري التحميل و الغاءه
  void rebuild() {
    load(true);
    load(false);
  }
}

// call طريقة استدعاء دالة

enum CallType {
  callAsStream, // يتم استدعاء الدالة يشكل متكرر
  callAsFuture, // يتم استدعاء الدالة مرة واحدة
  callIfModelEmpty, // يتم استدعاء الدالة عندما يكون النموذج فارغ
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

  McView(
      {Key? key,
      required this.model,
      required this.builder,
      this.call = _myDefaultFunc,
      this.callType = CallType.callAsFuture,
      this.secondsOfStream = 1,
      this.child,
      this.loader,
      this.tryAgainText = "Failed, try again",
      this.style,
      this.showExceptionDetails = false})
      : super(key: key, listenable: model) {
    // call التحقق من طريقة الاستدعاء لدالة
    switch (callType) {
      case CallType.callAsFuture:
        call();
        break;
      case CallType.callIfModelEmpty:
        if (model.multi == null) {
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
  final String tryAgainText;
  final ButtonStyle? style;
  final bool showExceptionDetails;

  @override
  Widget build(BuildContext context) {
    if (model.failed) {
      return Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  child: Text(tryAgainText),
                  onPressed: () {
                    model.setFailed(false);
                    call();
                  }),
              showExceptionDetails
                  ? ExpansionTile(
                      title: Text(
                        model.exception.split(":")[0],
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            model.exception,
                          ),
                        )
                      ],
                    )
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

// حاص بتخزين النماذج المستحدمة و الحفاظ على البياتات
class McController {
  static final McController _controller = McController._internal();
  Map<String, dynamic> models = {};
// اضافة تموذج جديد
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

// الوصول لنموذج
  T get<T>(String key) {
    return models[key];
  }

// حذف النموذح
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

/// Extensions

extension Mcless on StatelessWidget {
  McController get mc => McController();
}

extension Mcful on State {
  McController get mc => McController();
}

extension Sz on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get accentColor => Theme.of(this).accentColor;
  ScaffoldMessengerState get snc => ScaffoldMessenger.of(this);
  double get headline0 => this.median / 21.19; //28
  double get headline1 => this.median / 25.19; //28
  double get headline2 => this.median / 33.58; //24
  double get headline3 => this.median / 40.30; //18
  double get headline4 => this.median / 54.30; //15
  double get headline5 => this.median / 67.17; //12
  double get headline6 => this.median / 80.17; //9
  double get median =>
      (MediaQuery.of(this).size.height + MediaQuery.of(this).size.width) / 2;

  void push(Widget child) {
    Navigator.push(this, MaterialPageRoute(builder: (BuildContext context) {
      return child;
    }));
  }

  void pop() {
    Navigator.pop(this);
  }

  void pushR(Widget child) {
    Navigator.pushAndRemoveUntil(this,
        MaterialPageRoute(builder: (BuildContext context) {
      return child;
    }), (Route<dynamic> route) => false);
  }
}
