import 'dart:convert';

import 'package:dart_style/dart_style.dart';
import 'package:rocket_cli/src/utils/extensions.dart';

import 'controller/controller.dart';
import 'models/model.dart';
import 'utils/template.dart';

class Generator {
  late String copyTemplate;
  Future<void> generate(
      String inputUser, String className, ModelsController controller,
      {bool multi = false}) async {
    copyTemplate = template;
    className = className.isEmpty ? "MyModel" : className.firstUpper;
    inputUser =
        inputUser.isEmpty ? '{"MVCRocket Package":"MvcRocket"}' : inputUser;
    var jsonInputUser = json.decode(inputUser.trim());
    if (jsonInputUser is List) {
      return generate(json.encode(jsonInputUser.first), className, controller,
          multi: true);
    } else if (jsonInputUser is Map<String, dynamic>) {
      generateFields(jsonInputUser, className, controller, multi: multi);
    } else {
      print("Unsupported type");
    }
  }

  bool _isPrimitive(item) {
    return item is String || item is int || item is double || item is bool;
  }

  generateFields(Map<String, dynamic> fields, String className,
      ModelsController controller,
      {bool multi = false}) {
    ModelItems modelItems = ModelItems();
    fields.forEach((key, value) {
      String fieldType = _solveDouble(value);
      late String line;
      late String fromJson, toJson;
      String initFields = "";
      late String fieldsKey, updateFieldsParams, updateFieldsBody;
      final String fieldKeyMap =
          "${className.toLowerCase()}${key.camel.firstUpper}Field";
      final String fieldLine =
          'const String ${className.toLowerCase()}${key.camel.firstUpper}Field = "$key";';
      final String updateFieldParamLine = "$fieldType? ${key.camel}Field,";
      final String updateFieldBodyLine =
          "${key.camel} = ${key.camel}Field ?? ${key.camel};";
      bool isPrimitive = _isPrimitive(value);
      if (isPrimitive) {
        line = "$fieldType? ${key.camel};";
        fromJson = "${key.camel} = json[$fieldKeyMap];";
        toJson = "data[$fieldKeyMap] = ${key.camel};";
        fieldsKey = fieldLine;
        updateFieldsParams = updateFieldParamLine;
        updateFieldsBody = updateFieldBodyLine;
      } else if (value is List) {
        bool isNotEmpty = value.isNotEmpty;
        bool isPrimitive = false;
        if (isNotEmpty) isPrimitive = _isPrimitive(value.first);
        if (!isNotEmpty || isPrimitive) {
          final String fieldSubType =
              isNotEmpty ? _solveDouble(value.first) : "dynamic";
          line = "List<$fieldSubType>? ${key.camel};";
          fromJson = "${key.camel} = json[$fieldKeyMap];";
          toJson = "data[$fieldKeyMap] = ${key.camel};";
          fieldsKey = fieldLine;
          updateFieldsParams = "List<$fieldSubType>? ${key.camel}Field,";
          updateFieldsBody = updateFieldBodyLine;
        } else {
          line = "${key.firstUpper}? $key;";
          fromJson = "${key.camel}!.setMulti(json['$key']);";
          toJson =
              "data[$fieldKeyMap] = ${key.camel}!.multi.map((e)=> e.toJson()).toList();";
          fieldsKey = fieldLine;
          updateFieldsParams = "${key.firstUpper}? ${key.camel}Field,";
          updateFieldsBody = updateFieldBodyLine;
          initFields = "$key??=${key.firstUpper}();";

          Generator reGenerate = Generator();
          reGenerate.generate(json.encode(value), key.firstUpper, controller,
              multi: true);
        }
      } else if (value is Map) {
        line = "${key.firstUpper}? $key;";
        fromJson = "${key.camel}!.fromJson(json[$fieldKeyMap]);";
        toJson = "data[$fieldKeyMap] = ${key.camel}!.toJson();";
        fieldsKey = fieldLine;
        updateFieldsParams = "${key.firstUpper}? ${key.camel}Field,";
        updateFieldsBody = updateFieldBodyLine;
        initFields = "$key??=${key.firstUpper}();";

        Generator reGenerate = Generator();
        reGenerate.generate(json.encode(value), key.firstUpper, controller);
      } else {
        print("Unsupported type");
      }
      modelItems.constFields += "this.${key.camel},";
      modelItems.fieldsLines += line;
      modelItems.fromJsonFields += fromJson;
      modelItems.toJsonFields += toJson;
      modelItems.fieldsKey += fieldsKey;
      modelItems.updateFieldsParams += updateFieldsParams;
      modelItems.updateFieldsBody += updateFieldsBody;
      modelItems.initFields += initFields;
      if (multi) {
        modelItems.instance = "@override get instance => $className();";
      }
    });
    modelItems.className = className;
    String result = DartFormatter().format(modelItems.result);
    controller.addModel(result, className);
    // return controller;
  }

  String _solveDouble(dynamic field) {
    if (field is int) {
      if (field.isDouble) {
        return "double";
      }
    }
    return field.runtimeType.toString();
  }
}
