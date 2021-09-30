import 'package:flutter/material.dart';
import 'package:mc/src/mc_controller.dart';

/// Extensions helper

extension Mcless on StatelessWidget {
  McController get mc => McController();
}

extension Mcful on State {
  McController get mc => McController();
}
