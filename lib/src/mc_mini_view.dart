import 'package:flutter/material.dart';
import 'mc_constants.dart';
import 'mc_llistenable.dart';

class RocketMiniView extends StatefulWidget {
  final RocketListenable value;
  final Widget Function() builder;
  const RocketMiniView({Key? key, required this.value, required this.builder})
      : super(key: key);

  @override
  MiniViewRocketState createState() => MiniViewRocketState();
}

class MiniViewRocketState extends State<RocketMiniView> {
  @override
  void initState() {
    super.initState();
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
    if (widget.value.isMerged) {
      for (var mcValue in widget.value.merges) {
        mcValue.removeListener(rocketMergesRebuild, _rebuildWidget);
      }
    } else {
      widget.value.removeListener(rocketMiniRebuild, _rebuildWidget);
    }
    super.dispose();
  }

  void _rebuildWidget() {
    setState(() {
      // Rebuild widget.
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder();
  }
}
