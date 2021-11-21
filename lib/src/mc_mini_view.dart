import 'package:flutter/material.dart';
import 'package:mc/mc.dart';

class McMiniView extends StatefulWidget {
  final McValue mcValue;
  final Widget Function() builder;
  const McMiniView({
    Key? key,
   required  this.mcValue,
   required this.builder,
  }) : super(key: key);

  @override
  _McMiniViewState createState() => _McMiniViewState();
}

class _McMiniViewState extends State<McMiniView> {
  final String _initial = "valueChanged";
  @override
  void initState() {
    widget.mcValue.registerListener(_initial, _valueChanged);
    super.initState();
  }

  @override
  void didUpdateWidget(McMiniView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mcValue != oldWidget.mcValue) {
      oldWidget.mcValue.removeListener(_initial);
      widget.mcValue.registerListener(_initial, _valueChanged);
    }
  }

  @override
  void dispose() {
    widget.mcValue.removeListener(_initial);
    super.dispose();
  }

  void _valueChanged() {
    setState(() {
      // The listenable's state is our build state, and it changed already.
    });
  }
  @override
  Widget build(BuildContext context) {
    return widget.builder();
  }
}
