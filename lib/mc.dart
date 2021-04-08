library mc;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class McRequest extends McModel {
  final String url;
  final Map<String, String>? headers;

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
  McRequest({required this.url, this.headers});

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
      return {'Error': 'Failed to load Data: ${response.statusCode}'};
    }
  }

  @protected
  dynamic checkerObj(http.Response response, McModel model,
      {bool? multi, bool? complex, Function(dynamic data)? inspect}) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (multi!) {
        var result = json.decode(utf8.decode(response.bodyBytes));
        if (complex!) {
          result = inspect!(result);
          model.multi = [];
          model.setMulti(result);
        } else {
          model.multi = [];
          model.setMulti(result);
        }
        return model.multi;
      } else {
        var decoded = json.decode(utf8.decode(response.bodyBytes));
        var result = decoded.length == 0 ? model.toJson() : decoded[0];
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

  Future getObjData(String endpoint, McModel model,
      {Map<String, dynamic>? params,
      bool multi = false,
      bool complex = false,
      Function(dynamic data)? inspect}) async {
    model.load(true);
    String srch = params != null ? mapToString(params) : "";
    Uri url = Uri.parse(this.url + "/" + endpoint + '?' + srch);
    http.Response response = await http
        .get(url, headers: headers)
        .whenComplete(() => model.load(false));
    return checkerObj(response, model,
        multi: multi, complex: complex, inspect: inspect);
  }

  /// دالة خاصة بتعديل البيانات على شكل بالنموذج الذي تم تمريره مع الدالة
  ///
  ///[model]=>[النموذج]
  ///
  ///[inspect] => List<Map>

  Future<McModel> putObjData(int id, String endpoint, McModel model,
      {bool complex = false, Function(dynamic data)? inspect}) async {
    model.load(true);
    Uri url = Uri.parse(this.url + "/" + endpoint);
    http.Response response = await http
        .put(url, body: json.encode(model.toJson()), headers: headers)
        .whenComplete(() => model.load(false));
    return checkerObj(response, model, complex: complex, inspect: inspect);
  }

  /// دالة خاصة لتعديل البيانات بالقاموس الذي تم تمريره مع الدالة
  ///
  ///[Json]=>[قاموس]
  ///
  ///[inspect] => List<Map>

  Future putJsonData(int id, String endpoint, Map<String, dynamic> data,
      {bool complex = false, Function(dynamic data)? inspect}) async {
    Uri url = Uri.parse(this.url + "/" + endpoint);
    http.Response response =
        await http.put(url, body: json.encode(data), headers: headers);
    return checkerJson(response, complex: complex, inspect: inspect);
  }

  /// دالة خاصة بارسال البيانات على شكل النموذج الذي تم تمريره مع الدالة
  ///
  ///[model]=>[النموذج]
  ///
  ///[inspect] => List<Map>

  Future<McModel> postObjData(String endPoint, McModel model,
      {bool complex = false, Function(dynamic data)? inspect}) async {
    model.load(true);
    Uri url = Uri.parse(this.url + "/" + endPoint);
    http.Response response = await http
        .post(url, body: json.encode(model.toJson()), headers: headers)
        .whenComplete(() => model.load(false));

    return checkerObj(response, model, complex: complex, inspect: inspect);
  }

  /// دالة خاصة بارسال البيانات على شكل قاموس الذي تم تمريره مع الدالة
  ///
  ///[Json]=>[قاموس]
  ///
  ///[inspect] => List<Map>

  Future postJsonData(String endPoint, Map<String, dynamic> data,
      {bool complex = false, Function(dynamic data)? inspect}) async {
    Uri url = Uri.parse(this.url + "/" + endPoint);
    http.Response response =
        await http.post(url, body: json.encode(data), headers: headers);
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
    request.headers.addAll(this.headers!);

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
}

abstract class McModel extends ChangeNotifier {
  bool loading = false;
  List multi = [];

  void load(bool t) {
    loading = t;
    notifyListeners();
  }

  void delItem(int index) {
    multi.removeAt(index);
    notifyListeners();
  }

  setMulti(List? d) {
    notifyListeners();
  }

  fromJson(Map<String, dynamic>? json) {
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {};
  }

  void rebuild() {
    load(true);
    load(false);
  }
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
  const McView(
      {Key? key,
      required this.model,
      required this.builder,
      this.child,
      this.loader})
      : super(key: key, listenable: model);

  final TransitionBuilder builder;
  final Widget? child;
  final Widget? loader;
  final McModel model;

  @override
  Widget build(BuildContext context) {
    return model.loading
        ? Center(child: loader ?? CircularProgressIndicator())
        : builder(context, child);
  }
}

class McController {
  static final McController _controller = McController._internal();
  Map<String, McModel> models = {};

  McModel? add(String key, McModel model) {
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

  get(String key) {
    return models[key];
  }

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
