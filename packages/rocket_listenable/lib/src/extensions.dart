import 'dart:collection';

import 'package:flutter/material.dart';

import 'custom_linked_list.dart';

extension CustomLinkedList on LinkedList<CustomLinkedListEntry<VoidCallback>> {
  void removeWhere(
      bool Function(CustomLinkedListEntry<VoidCallback> element) test) {
    List<CustomLinkedListEntry<VoidCallback>>? removeIt = [];
    forEach((entry) {
      if (test(entry)) {
        removeIt.add(entry);
      }
    });
    if (removeIt.isNotEmpty) {
      for (var entry in removeIt) {
        remove(entry);
      }
    }
  }
}
