import 'package:flutter/material.dart';
import 'package:rocket_listenable/rocket_listenable.dart';

import 'constants.dart';

class RocketMiniView extends StatefulWidget {
  /// The `RocketValue` is `RocketListenable` object to listen to.
  final RocketListenable value;

  /// The function that returns the widget tree to build.
  final Widget Function() builder;

  /// A widget that listens to changes in a `RocketListenable` object and rebuilds when a change occurs.
  ///
  /// The `value` parameter is the `RocketValue` is `RocketListenable` object to listen to.
  ///
  /// The `builder` parameter is a function that returns the widget tree to build.
  ///
  /// Example usage:
  ///
  /// ```
  /// final RocketValue value = [].mini;
  /// ...
  /// RocketMiniView(
  ///   value: value,
  ///   builder: () {
  ///     return Text(value.length.toString());
  ///   },
  /// )
  /// ```
  const RocketMiniView({
    Key? key,
    required this.value,
    required this.builder,
  }) : super(key: key);

  @override
  MiniViewRocketState createState() => MiniViewRocketState();
}

/// The state object for the `RocketMiniView` widget.
class MiniViewRocketState extends State<RocketMiniView> {
  @override
  void initState() {
    super.initState();

    /// Register this listener to the `RocketListenable` object.
    if (widget.value.isMerged) {
      for (var mcValue in widget.value.merges) {
        mcValue.registerListener(rocketMergesRebuild, _rebuildWidget);
      }
    } else {
      widget.value.registerListener(rocketMiniRebuild, _rebuildWidget);
    }
  }

  @override
  void didUpdateWidget(RocketMiniView oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Update the listeners when the `value` parameter changes.
    if (widget.value.isMerged) {
      if (widget.value != oldWidget.value) {
        for (var mcValue in oldWidget.value.merges) {
          mcValue.removeListener(rocketMergesRebuild, _rebuildWidget);
        }
        for (var mcValue in widget.value.merges) {
          mcValue.registerListener(rocketMergesRebuild, _rebuildWidget);
        }
      }
    } else {
      if (widget.value != oldWidget.value) {
        oldWidget.value.removeListener(rocketMiniRebuild, _rebuildWidget);
        widget.value.registerListener(rocketMiniRebuild, _rebuildWidget);
      }
    }
  }

  @override
  void dispose() {
    /// Unregister the listener when the widget is disposed.
    if (widget.value.isMerged) {
      for (var mcValue in widget.value.merges) {
        mcValue.removeListener(rocketMergesRebuild, _rebuildWidget);
      }
    } else {
      widget.value.removeListener(rocketMiniRebuild, _rebuildWidget);
    }
    super.dispose();
  }

  /// Called when the `RocketListenable` object changes.
  void _rebuildWidget() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    /// Call the `builder` function to build the widget tree.
    return widget.builder();
  }
}
