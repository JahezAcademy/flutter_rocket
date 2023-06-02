import 'dart:collection';

import 'package:flutter/material.dart';

final class CustomLinkedListEntry<T>
    extends LinkedListEntry<CustomLinkedListEntry<VoidCallback>> {
  VoidCallback callBack;
  CustomLinkedListEntry(this.callBack);
  @override
  String toString() => '${super.toString()}: $callBack';
}
