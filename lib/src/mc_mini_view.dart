import 'package:flutter/material.dart';
import 'mc_constants.dart';
import 'mc_llistenable.dart';

class RocketMiniView extends StatefulWidget {
  final RocketListenable mcValue;
  final Widget Function() builder;
  const RocketMiniView(
    this.mcValue,
    this.builder, {
    Key? key,
  }) : super(key: key);

  @override
  MiniViewRocketState createState() => MiniViewRocketState();
}

class MiniViewRocketState extends State<RocketMiniView> {
  @override
  void initState() {
    super.initState();
    if (widget.mcValue.isMerged) {
      for (var mcValue in widget.mcValue.merges) {
        mcValue.registerListener(rocketMergesRebuild, _rebuildWidget);
      }
    } else {
      widget.mcValue.registerListener(rocketMiniRebuild, _rebuildWidget);
    }
  }

  @override
  void didUpdateWidget(RocketMiniView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mcValue.isMerged) {
      if (widget.mcValue != oldWidget.mcValue) {
        for (var mcValue in oldWidget.mcValue.merges) {
          mcValue.removeListener(rocketMergesRebuild, _rebuildWidget);
        }
        for (var mcValue in widget.mcValue.merges) {
          mcValue.registerListener(rocketMergesRebuild, _rebuildWidget);
        }
      }
    } else {
      if (widget.mcValue != oldWidget.mcValue) {
        oldWidget.mcValue.removeListener(rocketMiniRebuild, _rebuildWidget);
        widget.mcValue.registerListener(rocketMiniRebuild, _rebuildWidget);
      }
    }
  }

  @override
  void dispose() {
    if (widget.mcValue.isMerged) {
      for (var mcValue in widget.mcValue.merges) {
        mcValue.removeListener(rocketMergesRebuild, _rebuildWidget);
      }
    } else {
      widget.mcValue.removeListener(rocketMiniRebuild, _rebuildWidget);
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
