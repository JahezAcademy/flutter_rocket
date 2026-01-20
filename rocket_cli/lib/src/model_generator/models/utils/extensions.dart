extension EString on String {
  String get upper => toUpperCase();
  String get firstUpper =>
      isEmpty ? "" : substring(0, 1).toUpperCase() + substring(1);
  String get camel {
    if (isEmpty) return "";
    String internal = replaceAll(RegExp(r'[-_ ]'), '_');
    if (internal.contains("_")) {
      List<String> splited = internal.split("_");
      return splited.map((e) {
        if (splited.first == e) {
          return e.toLowerCase();
        }
        return e.firstUpper;
      }).join("");
    }
    return this[0].toLowerCase() + substring(1);
  }
}

extension EInt on num {
  bool get isDouble =>
      this is double || (this is int && toString().contains("."));
}
