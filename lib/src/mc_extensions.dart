import 'dart:collection';

import 'package:flutter/material.dart';

import 'mc_constants.dart';
import 'mc_llistenable.dart';
import 'mc_model.dart';
import 'mc_rocket.dart';
import 'mc_value_listenable.dart';

/// Extensions helper
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

extension AllToJson on List<RocketModel> {
  List toJson({List<String>? include, bool onlyValues = false}) {
    return map((e) {
      Map<String, dynamic> json = e.toJson();
      if (include != null) {
        json.removeWhere((key, value) => !include.contains(key));
      }
      return onlyValues ? json.values.toList() : json;
    }).toList();
  }
}

extension HasKey on HashMap {
  bool hasKey(String key) {
    bool checker = false;
    forEach((key, value) {
      if (key == key) checker = true;
    });
    return checker;
  }
}

extension Easy<T> on T {
  RocketValue<T> get mini {
    return RocketValue<T>(this);
  }
}

extension ToScreenSize on num {
  double get h {
    assert(Rocket.get(rocketSizeScreenKey) != null,
        "you should define sizeScreen put this line in init of first widget\nmc.add<Size>(sizeDesign, Size(context.width,context.height));");
    assert(Rocket.get(rocketSizeDesignKey) != null,
        "you should define designScreen put this line in init of first widget\nmc.add<Size>(sizeDesign, Size(width of your design, height of your design));");
    return (Rocket.get<Size>(rocketSizeScreenKey).height * this) /
        Rocket.get<Size>(rocketSizeDesignKey).height;
  }

  double get w {
    assert(Rocket.get(rocketSizeScreenKey) != null,
        "you should define sizeScreen put this line in init of first widget\nmc.add<Size>(sizeDesign, Size(context.width,context.height));");
    assert(Rocket.get(rocketSizeDesignKey) != null,
        "you should define designScreen put this line in init of first widget\nmc.add<Size>(sizeDesign, Size(width of your design, height of your design));");
    return (Rocket.get<Size>(rocketSizeScreenKey).width * this) /
        Rocket.get<Size>(rocketSizeDesignKey).width;
  }
}

// extension SizeDevice on BuildContext {
//   double get height => MediaQuery.of(this).size.height;
//   double get width => MediaQuery.of(this).size.width;
// }
