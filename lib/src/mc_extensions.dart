import 'dart:collection';
import 'dart:ui';
import 'package:mc/src/mc_controller.dart';
import 'mc_constants.dart';
import 'mc_llistenable.dart';

/// Extensions helper

/// لتسهيل الوصول ل [McController]

extension McInObj on Object {
  McController get mc => McController();
}

extension CustomLinkedList on LinkedList<MyLinkedListEntry<VoidCallback>> {
  void removeWhere(bool test(MyLinkedListEntry<VoidCallback> element)) {
    List<MyLinkedListEntry<VoidCallback>>? removeIt = [];
    forEach((entry) {
      if (test(entry)) {
        removeIt.add(entry);
      }
    });
    if (removeIt.isNotEmpty)
      removeIt.forEach((entry) {
        remove(entry);
      });
  }
}

extension HasKey on HashMap {
  bool hasKey(String key) {
    bool checker = false;
    this.forEach((_key, value) {
      if (key == _key) checker = true;
    });
    return checker;
  }
}

extension toScreenSize on num {
  double get h =>
      (McController().get(heightScreen) * this) /
      McController().get(heightDesign);
  double get w =>
      (McController().get(widthScreen) * this) /
      McController().get(widthDesign);
}
