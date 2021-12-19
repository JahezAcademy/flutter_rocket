import 'dart:collection';
import 'dart:ui';

import 'package:mc/src/mc_controller.dart';

import 'mc_llistenable.dart';

/// Extensions helper
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
