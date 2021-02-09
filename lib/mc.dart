library mc;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class McRequest {
  final String url;
  final Map<String, dynamic> headers;

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
  McRequest({@required this.url, this.headers});

  @protected
  checkerJson(http.Response response) {
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      print({'Error': 'Failed to load Data: ${response.statusCode}'});
      return {'Error': 'Failed to load Data: ${response.statusCode}'};
    }
  }

  @protected
  McModel checkerObj(http.Response response, McModel model, {bool multi}) {
    if (response.statusCode == 200) {
      if (multi) {
        List result = json.decode(utf8.decode(response.bodyBytes));
        model.setMulti(result);
        return model;
      } else {
        try {
          List decoded = json.decode(utf8.decode(response.bodyBytes));
          var result = decoded.length == 0 ? model.toJson() : decoded[0];
          model.fromJson(result);
          return model;
        } catch (e) {
          Map result = json.decode(utf8.decode(response.bodyBytes));
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
  Future<Map<String, dynamic>> getJsonData(String endpoint,
      {Map search, bool multi = false}) async {
    String srch = search != null ? mapToString(search) : "";
    http.Response response =
        await http.get(this.url + endpoint + "?" + srch, headers: headers);
    return checkerJson(response);
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

  Future<McModel> getObjData(String endpoint, McModel model,
      {Map search, bool multi = false}) async {
    model.load(true);
    String srch = search != null ? mapToString(search) : "";
    http.Response response = await http
        .get(url + endpoint + "?" + srch, headers: headers)
        .whenComplete(() => model.load(false));

    return checkerObj(response, model, multi: multi);
  }

  /// دالة خاصة بتعديل البيانات على شكل بالنموذج الذي تم تمريره مع الدالة
  ///
  ///[model]=>[النموذج]
  ///

  Future<McModel> putObjData(int id, String endpoint, McModel model) async {
    model.load(true);
    http.Response response = await http
        .put("$url/$endpoint/$id/",
            body: json.encode(model.toJson()), headers: headers)
        .whenComplete(() => model.load(false));
    return checkerObj(response, model);
  }

  /// دالة خاصة لتعديل البيانات بالقاموس الذي تم تمريره مع الدالة
  ///
  ///[Json]=>[قاموس]
  ///

  Future putJsonData(int id, String endpoint, Map<String, dynamic> data) async {
    http.Response response = await http.put("$url/$endpoint/$id/",
        body: json.encode(data), headers: headers);
    return checkerJson(response);
  }

  /// دالة خاصة بارسال البيانات على شكل النموذج الذي تم تمريره مع الدالة
  ///
  ///[model]=>[النموذج]
  ///

  Future<McModel> postObjData(String endPoint, McModel model) async {
    model.load(true);
    http.Response response = await http
        .post("$url$endPoint/",
            body: json.encode(model.toJson()), headers: headers)
        .whenComplete(() => model.load(false));

    return checkerObj(response, model);
  }

  /// دالة خاصة بارسال البيانات على شكل قاموس الذي تم تمريره مع الدالة
  ///
  ///[Json]=>[قاموس]
  ///

  Future postJsonData(String endPoint, Map<String, dynamic> data) async {
    http.Response response = await http.post("$url$endPoint/",
        body: json.encode(data), headers: headers);
    return checkerJson(response);
  }

  /// دالة خاصة بحذف البيانات عن طريق ر.م الخاص بهم
  ///
  ///[id]=>[ر.م]
  ///
  Future delJsonData(int id, String endpoint) async {
    http.Response response =
        await http.delete("$url/$endpoint/$id/", headers: headers);
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

  setMulti(List d) {
    notifyListeners();
  }

  fromJson(Map<String, dynamic> json) {
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {};
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
      {Key key,
      @required this.model,
      @required this.builder,
      this.child,
      this.loader})
      : assert(model != null),
        assert(builder != null),
        super(key: key, listenable: model);

  final TransitionBuilder builder;
  final Widget child;
  final Widget loader;
  final McModel model;

  @override
  Widget build(BuildContext context) {
    return model.loading
        ? Center(child: loader ?? CircularProgressIndicator())
        : builder(context, child);
  }
}
