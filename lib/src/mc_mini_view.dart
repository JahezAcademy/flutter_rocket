import 'package:flutter/material.dart';
import 'mc_constants.dart';
import 'mc_llistenable.dart';

class McMV extends StatefulWidget {
  final McListenable mcValue;
  final Widget Function() builder;
  const McMV(
    this.mcValue,
    this.builder, {
    Key? key,
  }) : super(key: key);

  @override
  _McMVState createState() => _McMVState();
}

class _McMVState extends State<McMV> {
  @override
  void initState() {
    super.initState();
    if (widget.mcValue.isMerged) {
      widget.mcValue.merges.forEach((mcValue) {
        mcValue.registerListener(mergesRebuild, _rebuildWidget);
      });
    } else {
      widget.mcValue.registerListener(miniRebuild, _rebuildWidget);
    }
  }

  @override
  void didUpdateWidget(McMV oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mcValue.isMerged) {
      if (widget.mcValue != oldWidget.mcValue) {
        oldWidget.mcValue.merges.forEach((mcValue) {
          mcValue.removeListener(mergesRebuild, _rebuildWidget);
        });
        widget.mcValue.merges.forEach((mcValue) {
          mcValue.registerListener(mergesRebuild, _rebuildWidget);
        });
      }
    } else {
      if (widget.mcValue != oldWidget.mcValue) {
        oldWidget.mcValue.removeListener(miniRebuild, _rebuildWidget);
        widget.mcValue.registerListener(miniRebuild, _rebuildWidget);
      }
    }
  }

  @override
  void dispose() {
    if (widget.mcValue.isMerged) {
      widget.mcValue.merges.forEach((mcValue) {
        mcValue.removeListener(mergesRebuild, _rebuildWidget);
      });
    } else {
      widget.mcValue.removeListener(miniRebuild, _rebuildWidget);
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
