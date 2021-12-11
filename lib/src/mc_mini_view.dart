import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import 'mc_llistenable.dart';

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
  final String _valueChanged = "valueChanged";
  final String _mergesChanged = "mergesChanged";
  @override
  void initState() {
    super.initState();
    if (widget.mcValue.isMerged) {
      widget.mcValue.merges.forEach((mcValue) {
        mcValue.registerListener(_mergesChanged, _rebuildWidget);
      });
    } else {
      widget.mcValue.registerListener(_valueChanged, _rebuildWidget);
    }
  }

  @override
  void didUpdateWidget(McMiniView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mcValue.isMerged) {
      if (widget.mcValue != oldWidget.mcValue) {
        oldWidget.mcValue.merges.forEach((mcValue) {
          mcValue.removeListener(_valueChanged);
        });
        widget.mcValue.merges.forEach((mcValue) {
          mcValue.registerListener(_valueChanged, _rebuildWidget);
        });
      }
    } else {
      if (widget.mcValue != oldWidget.mcValue) {
        oldWidget.mcValue.removeListener(_valueChanged);
        widget.mcValue.registerListener(_valueChanged, _rebuildWidget);
      }
    }
  }

  @override
  void dispose() {
    if (widget.mcValue.isMerged) {
      widget.mcValue.merges.forEach((mcValue) {
        mcValue.removeListener(_valueChanged);
      });
    } else {
      widget.mcValue.removeListener(_valueChanged);
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

extension Easy<T> on T {
  McValue<T> get mini {
    return McValue<T>(this);
  }
}
