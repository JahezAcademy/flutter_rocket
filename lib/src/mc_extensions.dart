import 'dart:collection';
import 'package:flutter/material.dart';
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

extension ToScreenSize on num {
  double get h {
    assert(McController().get(sizeScreen) != null,
        "you should define sizeScreen put this line in init of first widget\nmc.add<Size>(sizeDesign, Size(context.width,context.height));");
    assert(McController().get(sizeDesign) != null,
        "you should define designScreen put this line in init of first widget\nmc.add<Size>(sizeDesign, Size(width of your design, height of your design));");
    return (McController().get<Size>(sizeScreen).height * this) /
        McController().get<Size>(sizeDesign).height;
  }

  double get w {
    assert(McController().get(sizeScreen) != null,
        "you should define sizeScreen put this line in init of first widget\nmc.add<Size>(sizeDesign, Size(context.width,context.height));");
    assert(McController().get(sizeDesign) != null,
        "you should define designScreen put this line in init of first widget\nmc.add<Size>(sizeDesign, Size(width of your design, height of your design));");
    return (McController().get<Size>(sizeScreen).width * this) /
        McController().get<Size>(sizeDesign).width;
  }
}

extension SizeScreen on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
}
