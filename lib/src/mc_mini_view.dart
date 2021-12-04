import 'package:flutter/material.dart';
import 'mc_llistenable.dart';

class McMiniView extends StatefulWidget {
  final McListenable mcValue;
  final Widget Function() builder;
  const McMiniView(
    this.builder, 
    this.mcValue,{
    Key? key,
  }) : super(key: key);

  @override
  _McMiniViewState createState() => _McMiniViewState();
}

class _McMiniViewState extends State<McMiniView> {
  final String _initial = "valueChanged";
  @override
  void initState() {
    super.initState();
    widget.mcValue.registerListener(_initial, _valueChanged);
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
      // Rebuild widget.
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder();
  }
}
