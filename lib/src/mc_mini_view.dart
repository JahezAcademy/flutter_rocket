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
  _MiniViewRocketState createState() => _MiniViewRocketState();
}

class _MiniViewRocketState extends State<RocketMiniView> {
  @override
  void initState() {
    super.initState();
    if (widget.mcValue.isMerged) {
      widget.mcValue.merges.forEach((mcValue) {
        mcValue.registerListener(rocketMergesRebuild, _rebuildWidget);
      });
    } else {
      widget.mcValue.registerListener(rocketMiniRebuild, _rebuildWidget);
    }
  }

  @override
  void didUpdateWidget(RocketMiniView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mcValue.isMerged) {
      if (widget.mcValue != oldWidget.mcValue) {
        oldWidget.mcValue.merges.forEach((mcValue) {
          mcValue.removeListener(rocketMergesRebuild, _rebuildWidget);
        });
        widget.mcValue.merges.forEach((mcValue) {
          mcValue.registerListener(rocketMergesRebuild, _rebuildWidget);
        });
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
      widget.mcValue.merges.forEach((mcValue) {
        mcValue.removeListener(rocketMergesRebuild, _rebuildWidget);
      });
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
