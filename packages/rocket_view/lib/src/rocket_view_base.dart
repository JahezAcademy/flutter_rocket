import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rocket_model/rocket_model.dart';

import 'enums.dart';

typedef OnError = Widget Function(RocketException error, Function() reload)?;

/// A widget that helps to manage the state of a [RocketModel] and handle
/// the different states of the data (loading, done, failed).
///
/// The [builder] parameter is a function that takes a [BuildContext] and a [RocketState]
/// and returns a widget tree.
///
/// The [fetch] parameter is a function that is called to fetch data.
///
/// The [callType] parameter determines when the [fetch] function is called:
/// - [CallType.callAsFuture]: Called immediately
/// - [CallType.callIfModelEmpty]: Called only if the model has no data
///
/// Example usage:
/// ```dart
/// RocketView(
///   model: myModel,
///   builder: (context, state) {
///     if (state == RocketState.loading) {
///       return const Center(child: CircularProgressIndicator());
///     } else if (state == RocketState.done) {
///       return ListView.builder(...);
///     } else {
///       return Text('An error occurred!');
///     }
///   },
///   fetch: ({bool refresh = false}) async => await myModel.fetchData(),
///   callType: CallType.callAsFuture,
///   onError: (error, reload) => Text('Error: ${error.response}'),
/// )
/// ```
class RocketView<T> extends StatefulWidget {
  /// The function that builds the widget tree based on the state.
  final Widget Function(BuildContext, RocketState) builder;

  /// The function that fetches data.
  final FutureOr Function({bool refresh})? fetch;

  /// When to call the [fetch] function.
  final CallType callType;

  /// The widget to display while data is loading.
  /// If null, a default loading indicator is shown based on the state.
  final Widget Function()? onLoading;

  /// The [RocketModel] object that holds the data and state.
  final RocketModel<T> model;

  /// The function to call if an error occurs.
  /// If null, a default error UI with retry button is shown.
  final OnError onError;

  /// Specific fields to listen to for selective rebuilds.
  /// If null, the view listens to the entire model.
  final List<String>? fields;

  /// Enable refresh data by pull to refresh.
  final bool refresh;

  const RocketView({
    Key? key,
    required this.model,
    required this.builder,
    this.fetch,
    this.callType = CallType.callAsFuture,
    this.onLoading,
    this.onError,
    this.fields,
    this.refresh = true,
  }) : super(key: key);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<RocketModel>('RocketModel', model));
  }

  @override
  ViewRocketState createState() => ViewRocketState();
}

/// The state object for the [RocketView] widget.
class ViewRocketState extends State<RocketView> {
  /// The function to call to reload data.
  late Function() reload;

  @override
  void initState() {
    reload = () {
      widget.model.state = RocketState.loading;
      widget.fetch?.call();
    };
    _registerListeners();

    switch (widget.callType) {
      case CallType.callAsFuture:
        widget.fetch?.call();
        break;
      case CallType.callIfModelEmpty:
        if (!widget.model.existData) {
          widget.fetch?.call();
        }
        break;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(RocketView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      _unregisterListeners(oldWidget.model);
      _registerListeners();
    }
  }

  @override
  void dispose() {
    _unregisterListeners(widget.model);
    super.dispose();
  }

  void _registerListeners() {
    if (widget.fields != null) {
      for (var field in widget.fields!) {
        widget.model.registerListener(field, _handleChange);
      }
    } else {
      widget.model.registerListener(rocketRebuild, _handleChange);
    }
  }

  void _unregisterListeners(RocketModel model) {
    if (widget.fields != null) {
      for (var field in widget.fields!) {
        model.removeListener(field, _handleChange);
      }
    } else {
      model.removeListener(rocketRebuild, _handleChange);
    }
  }

  /// Called when a change occurs in the [RocketModel].
  void _handleChange() {
    if (!mounted) return;
    // Use a microtask to avoid issues if notifyListeners was called during a build
    Future.microtask(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  /// Returns the appropriate widget tree based on the [RocketState].
  Widget _handleStates() {
    switch (widget.model.state) {
      case RocketState.loading:
        return widget.onLoading != null
            ? widget.onLoading!()
            : _handleSilentLoading(context);
      case RocketState.done:
        return widget.builder(context, widget.model.state);
      case RocketState.failed:
        return widget.onError != null
            ? widget.onError!(widget.model.exception, reload)
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.model.exception.exception.toString()),
                    TextButton(onPressed: reload, child: const Text("Retry"))
                  ],
                ),
              );
    }
  }

  Widget _handleSilentLoading(BuildContext context) {
    if (widget.model.state == RocketState.loading &&
        !widget.model.isPaginated) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return widget.builder(context, widget.model.state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.refresh
        ? RefreshIndicator(
            onRefresh: () async {
              await widget.fetch?.call(refresh: true);
            },
            child: _handleStates(),
          )
        : _handleStates();
  }
}
