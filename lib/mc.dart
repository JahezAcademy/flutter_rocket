library mc;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class McRequest extends McModel {
  final String url;
  final Map<String, dynamic>? headers;

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
  checkerJson(http.Response response, {String? path}) {
    if (response.statusCode == 200) {
      Map? data = json.decode(utf8.decode(response.bodyBytes));
      if (path!.isNotEmpty) {
        data = data!.getFromPath(path);
      }
      return data;
    } else {
      print({'Error': 'Failed to load Data: ${response.statusCode}'});
      return {'Error': 'Failed to load Data: ${response.statusCode}'};
    }
  }

  @protected
  dynamic checkerObj(http.Response response, McModel model,
      {bool? multi, String? path}) {
    if (response.statusCode == 200) {
      if (multi!) {
        var result = json.decode(utf8.decode(response.bodyBytes));
        if (result.runtimeType.toString() ==
            "_InternalLinkedHashMap<String, dynamic>") {
          Map toMap = result;
          toMap = toMap.getFromPath(path!, multi);
          model.setMulti(toMap['result']);
        } else {
          model.setMulti(result);
        }

        return model.multi;
      } else {
        try {
          List decoded = json.decode(utf8.decode(response.bodyBytes));
          var result = decoded.length == 0 ? model.toJson() : decoded[0];
          model.fromJson(result);
          return model;
        } catch (e) {
          Map? result = json.decode(utf8.decode(response.bodyBytes));
          if (path!.isNotEmpty) {
            model.fromJson(result!.getFromPath(path) as Map<String, dynamic>?);
          } else {
            model.fromJson(result as Map<String, dynamic>?);
          }

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
  Map? getFromPath(String path, Map data) {
    path.split('/').forEach((e) {
      data = data[e];
    });
    return data;
  }

  // @protected
  // String mapToString(Map mp) {
  //   String result = "";
  //   mp.forEach((key, value) {
  //     String and = mp.keys.last != key ? "&" : "";
  //     result = result + key + "=" + value.toString() + and;
  //   });
  //   return result;
  // }

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
  Future getJsonData(String endpoint,
      {Map<String, dynamic>? params,
      bool multi = false,
      String path = ""}) async {
    //String srch = params != null ? mapToString(params) : "";
    Uri url = Uri.https(this.url, "/" + endpoint, params);
    http.Response response =
        await http.get(url, headers: headers as Map<String, String>?);
    return checkerJson(response, path: path);
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

  Future getObjData(String endpoint, McModel model,
      {Map<String, dynamic>? params,
      bool multi = false,
      String path = ""}) async {
    model.load(true);
    // String srch = params != null ? mapToString(params) : "";*
    Uri url = Uri.https(this.url, "/" + endpoint, params);
    http.Response response = await http
        .get(url, headers: headers as Map<String, String>?)
        .whenComplete(() => model.load(false));
    return checkerObj(response, model, multi: multi, path: path);
  }

  /// دالة خاصة بتعديل البيانات على شكل بالنموذج الذي تم تمريره مع الدالة
  ///
  ///[model]=>[النموذج]
  ///

  Future<McModel> putObjData(int id, String endpoint, McModel model) async {
    model.load(true);
    Uri url = Uri.https(this.url, "/" + endpoint);
    http.Response response = await http
        .put(url,
            body: json.encode(model.toJson()),
            headers: headers as Map<String, String>?)
        .whenComplete(() => model.load(false));
    return checkerObj(response, model);
  }

  /// دالة خاصة لتعديل البيانات بالقاموس الذي تم تمريره مع الدالة
  ///
  ///[Json]=>[قاموس]
  ///

  Future putJsonData(int id, String endpoint, Map<String, dynamic> data) async {
    Uri url = Uri.https(this.url, "/" + endpoint);
    http.Response response = await http.put(url,
        body: json.encode(data), headers: headers as Map<String, String>?);
    return checkerJson(response);
  }

  /// دالة خاصة بارسال البيانات على شكل النموذج الذي تم تمريره مع الدالة
  ///
  ///[model]=>[النموذج]
  ///

  Future<McModel> postObjData(String endPoint, McModel model) async {
    model.load(true);
    Uri url = Uri.https(this.url, "/" + endPoint);
    http.Response response = await http
        .post(url,
            body: json.encode(model.toJson()),
            headers: headers as Map<String, String>?)
        .whenComplete(() => model.load(false));

    return checkerObj(response, model);
  }

  /// دالة خاصة بارسال البيانات على شكل قاموس الذي تم تمريره مع الدالة
  ///
  ///[Json]=>[قاموس]
  ///

  Future postJsonData(String endPoint, Map<String, dynamic> data) async {
    Uri url = Uri.https(this.url, "/" + endPoint);
    http.Response response = await http.post(url,
        body: json.encode(data), headers: headers as Map<String, String>?);
    return checkerJson(response);
  }

  /// دالة خاصة بحذف البيانات عن طريق ر.م الخاص بهم
  ///
  ///[id]=>[ر.م]
  ///
  Future delJsonData(int id, String endpoint) async {
    Uri url = Uri.https(this.url, "/" + id.toString());
    http.Response response =
        await http.delete(url, headers: headers as Map<String, String>?);
    var decoded = json.decode(response.body);
    return decoded;
  }
}

class McModel extends ChangeNotifier {
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

  void add(String key, McModel model) {
    if (key.contains('!')) {
      if (!models.containsKey(key.substring(1))) {
        models[key.substring(1)] = model;
      }
    } else {
      models[key] = model;
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

extension FromPath on Map {
  Map getFromPath(String path, [bool multi = false]) {
    Map result = this;
    List pth = path.split('/');
    pth.remove("");
    pth.forEach((e) {
      try {
        if (e.contains('[')) {
          if (multi) {
            result = {"result": result[e.substring(1)]};
          } else {
            result = result[e.substring(1)][0];
          }
        } else if (e.contains('{')) {
          result = result[e.substring(1)];
        }
      } catch (e) {
        print(e);
        print(
            "this path not correct please write correct path example\n data=> {'data':{'user':[{'first_name','Mohammed'}]}}\nCorrect path for this data is {data/[user");
      }
    });
    return result;
  }
}
