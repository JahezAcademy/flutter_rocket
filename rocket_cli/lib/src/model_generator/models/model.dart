import 'utils/template.dart';

class ModelItems {
  String fieldsLines = "";
  String constFields = "";
  String fromJsonFields = "";
  String toJsonFields = "";
  String instance = "";
  String className = "";
  String fieldsKey = "";
  String updateFieldsParams = "";
  String updateFieldsBody = "";
  String initFields = "{";
  String get result {
    initFields = initFields.length > 1 ? "$initFields}" : ";";
    return template
        .replaceFirst("-fields-", fieldsLines)
        .replaceFirst("-fieldsConstructor-", constFields)
        .replaceFirst("-fromJsonFields-", fromJsonFields)
        .replaceFirst("-toJsonFields-", toJsonFields)
        .replaceAll("-name-", className)
        .replaceFirst("-instance-", instance)
        .replaceFirst("-fieldsKey-", fieldsKey)
        .replaceFirst("-updateFieldsParams-", updateFieldsParams)
        .replaceFirst("-updateFieldsBody-", updateFieldsBody)
        .replaceFirst("-initFields-", initFields);
  }
}
