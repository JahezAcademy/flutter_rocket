const String template = """import 'package:flutter_rocket/flutter_rocket.dart';

-fieldsKey-

class -name- extends RocketModel<-name-> {
  -fields-

  -name-({
    -fieldsConstructor-
  })-initFields-

  @override
  void fromJson(Map<String, dynamic>? json, {bool isSub = false}) {
    if(json == null) return;
    -fromJsonFields-
    super.fromJson(json, isSub: isSub);
  }

  void updateFields({
   -updateFieldsParams-
  }) {
    List<String> fields = [];
    -updateFieldsBody-
    rebuildWidget(fromUpdate: true, fields: fields.isEmpty ? null : fields);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    -toJsonFields-

    return data;
  }

  -instance-
}""";
