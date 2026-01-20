import 'dart:convert';

import 'package:dart_style/dart_style.dart';
import 'package:rocket_cli/src/model_generator/models/utils/extensions.dart';

import 'controller/controller.dart';
import 'model.dart';
import 'utils/template.dart';

class Generator {
  late String copyTemplate;
  final Set<String> _generatedClasses = {};

  Future<void> generate(
      String inputUser, String className, ModelsController controller,
      {bool multi = false}) async {
    copyTemplate = template;
    className = className.isEmpty ? "MyModel" : className.firstUpper;

    if (_generatedClasses.contains(className)) return;

    inputUser =
        inputUser.isEmpty ? '{"MVCRocket Package":"MvcRocket"}' : inputUser;

    dynamic jsonInputUser;
    try {
      jsonInputUser = json.decode(inputUser.trim());
    } catch (e) {
      print("Error decoding JSON: $e");
      return;
    }

    if (jsonInputUser is List) {
      if (jsonInputUser.isEmpty) {
        print("Empty list, cannot infer type for $className");
        return;
      }
      return generate(json.encode(jsonInputUser.first), className, controller,
          multi: true);
    } else if (jsonInputUser is Map<String, dynamic>) {
      _generatedClasses.add(className);
      generateFields(jsonInputUser, className, controller, multi: multi);
    } else {
      print("Unsupported JSON type for $className");
    }
  }

  bool _isPrimitive(item) {
    return item is String || item is int || item is double || item is bool;
  }

  bool _isDateField(String value) {
    return DateTime.tryParse(value) != null &&
        RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(value);
  }

  generateFields(Map<String, dynamic> fields, String className,
      ModelsController controller,
      {bool multi = false}) {
    ModelItems modelItems = ModelItems();
    fields.forEach((key, value) {
      String fieldType = _solveType(value);
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
          "if (${key.camel}Field != null) { ${key.camel} = ${key.camel}Field; fields.add($fieldKeyMap); }";

      bool isPrimitive = _isPrimitive(value);

      if (value == null) {
        line = "dynamic? ${key.camel};";
        fromJson = "${key.camel} = json[$fieldKeyMap];";
        toJson = "data[$fieldKeyMap] = ${key.camel};";
        fieldsKey = fieldLine;
        updateFieldsParams = "dynamic? ${key.camel}Field,";
        updateFieldsBody = updateFieldBodyLine;
      } else if (isPrimitive) {
        line = "$fieldType? ${key.camel};";
        if (fieldType == "DateTime") {
          fromJson =
              "${key.camel} = json[$fieldKeyMap] != null ? DateTime.tryParse(json[$fieldKeyMap].toString()) : null;";
          toJson = "data[$fieldKeyMap] = ${key.camel}?.toIso8601String();";
        } else {
          fromJson = "${key.camel} = json[$fieldKeyMap];";
          toJson = "data[$fieldKeyMap] = ${key.camel};";
        }
        fieldsKey = fieldLine;
        updateFieldsParams = updateFieldParamLine;
        updateFieldsBody = updateFieldBodyLine;
      } else if (value is List) {
        bool isNotEmpty = value.isNotEmpty;
        bool isListOrPrimitive = false;

        dynamic firstItem = isNotEmpty ? value.first : null;
        if (isNotEmpty) {
          isListOrPrimitive = _isPrimitive(firstItem) || firstItem is List;
        }

        if (!isNotEmpty || isListOrPrimitive) {
          final String fieldSubType =
              isNotEmpty ? _solveType(firstItem) : "dynamic";
          line = "List<$fieldSubType>? ${key.camel};";
          fromJson =
              "${key.camel} = json[$fieldKeyMap]?.cast<$fieldSubType>();";
          toJson = "data[$fieldKeyMap] = ${key.camel};";
          fieldsKey = fieldLine;
          updateFieldsParams = "List<$fieldSubType>? ${key.camel}Field,";
          updateFieldsBody = updateFieldBodyLine;
        } else {
          String subClassName = key.camel.firstUpper;
          line = "$subClassName? ${key.camel};";
          fromJson =
              "if (json[$fieldKeyMap] != null) ${key.camel}!.setMulti(json[$fieldKeyMap]);";
          toJson =
              "data[$fieldKeyMap] = ${key.camel}!.all?.map((e)=> e.toJson()).toList();";
          fieldsKey = fieldLine;
          updateFieldsParams = "$subClassName? ${key.camel}Field,";
          updateFieldsBody = updateFieldBodyLine;
          initFields = "${key.camel}??=$subClassName();";

          generate(json.encode(value), subClassName, controller, multi: true);
        }
      } else if (value is Map<String, dynamic>) {
        String subClassName = key.camel.firstUpper;
        line = "$subClassName? ${key.camel};";
        fromJson = "${key.camel}!.fromJson(json[$fieldKeyMap]);";
        toJson = "data[$fieldKeyMap] = ${key.camel}!.toJson();";
        fieldsKey = fieldLine;
        updateFieldsParams = "$subClassName? ${key.camel}Field,";
        updateFieldsBody = updateFieldBodyLine;
        initFields = "${key.camel}??=$subClassName();";

        generate(json.encode(value), subClassName, controller);
      } else {
        print("Unsupported type for key: $key");
      }

      modelItems.constFields += "this.${key.camel},";
      modelItems.fieldsLines += line;
      modelItems.fromJsonFields += fromJson;
      modelItems.toJsonFields += toJson;
      modelItems.fieldsKey += fieldsKey;
      modelItems.updateFieldsParams += updateFieldsParams;
      modelItems.updateFieldsBody += updateFieldsBody;
      modelItems.initFields += initFields;
    });

    if (multi) {
      modelItems.instance =
          "@override $className get instance => $className();";
    }

    modelItems.className = className;
    try {
      String result = DartFormatter().format(modelItems.result);
      controller.addModel(result, className);
    } catch (e) {
      print("Error formatting $className: $e");
      controller.addModel(modelItems.result, className);
    }
  }

  String _solveType(dynamic field) {
    if (field == null) return "dynamic";
    if (field is String) {
      if (_isDateField(field)) return "DateTime";
      return "String";
    }
    if (field is bool) return "bool";
    if (field is num) {
      if (field.isDouble) {
        return "double";
      }
      return "int";
    }
    if (field is List) {
      String subType = field.isNotEmpty ? _solveType(field.first) : "dynamic";
      return "List<$subType>";
    }
    return field.runtimeType.toString();
  }
}
