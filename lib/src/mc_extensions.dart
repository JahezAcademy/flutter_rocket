import 'dart:collection';
import 'package:flutter/material.dart';
import 'mc_controller.dart';
import 'mc_constants.dart';
import 'mc_llistenable.dart';

/// Extensions helper

/// لتسهيل الوصول ل [RocketController]

extension RocketInObj on Object {
  RocketController get rocket => RocketController();
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
    assert(RocketController().get(sizeScreenKey) != null,
        "you should define sizeScreen put this line in init of first widget\nmc.add<Size>(sizeDesign, Size(context.width,context.height));");
    assert(RocketController().get(sizeDesignKey) != null,
        "you should define designScreen put this line in init of first widget\nmc.add<Size>(sizeDesign, Size(width of your design, height of your design));");
    return (RocketController().get<Size>(sizeScreenKey).height * this) /
        RocketController().get<Size>(sizeDesignKey).height;
  }

  double get w {
    assert(RocketController().get(sizeScreenKey) != null,
        "you should define sizeScreen put this line in init of first widget\nmc.add<Size>(sizeDesign, Size(context.width,context.height));");
    assert(RocketController().get(sizeDesignKey) != null,
        "you should define designScreen put this line in init of first widget\nmc.add<Size>(sizeDesign, Size(width of your design, height of your design));");
    return (RocketController().get<Size>(sizeScreenKey).width * this) /
        RocketController().get<Size>(sizeDesignKey).width;
  }
}

extension SizeDevice on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
}
