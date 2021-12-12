import 'package:flutter/material.dart';
import 'mc_llistenable.dart';
import 'mc_value_listenable.dart';

class McMiniView extends StatefulWidget {
  final McListenable mcValue;
  final Widget Function() builder;
  const McMiniView(
    this.builder,
    this.mcValue, {
    Key? key,
  }) : super(key: key);

  @override
  _McMiniViewState createState() => _McMiniViewState();
}

class _McMiniViewState extends State<McMiniView> {
  @override
  void initState() {
    super.initState();
    if (widget.mcValue.isMerged) {
      widget.mcValue.merges.forEach((mcValue) {
        mcValue.registerListener(McValue.mergesRebuild, _rebuildWidget);
      });
    } else {
      widget.mcValue.registerListener(McValue.miniRebuild, _rebuildWidget);
    }
  }

  @override
  void didUpdateWidget(McMiniView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mcValue.isMerged) {
      if (widget.mcValue != oldWidget.mcValue) {
        oldWidget.mcValue.merges.forEach((mcValue) {
          mcValue.removeListener(McValue.mergesRebuild);
        });
        widget.mcValue.merges.forEach((mcValue) {
          mcValue.registerListener(McValue.mergesRebuild, _rebuildWidget);
        });
      }
    } else {
      if (widget.mcValue != oldWidget.mcValue) {
        oldWidget.mcValue.removeListener(McValue.miniRebuild);
        widget.mcValue.registerListener(McValue.miniRebuild, _rebuildWidget);
      }
    }
  }

  @override
  void dispose() {
    if (widget.mcValue.isMerged) {
      widget.mcValue.merges.forEach((mcValue) {
        mcValue.removeListener(McValue.mergesRebuild);
      });
    } else {
      widget.mcValue.removeListener(McValue.miniRebuild);
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

