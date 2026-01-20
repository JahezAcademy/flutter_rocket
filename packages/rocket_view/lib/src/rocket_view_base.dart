import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rocket_model/rocket_model.dart';

import 'enums.dart';

typedef OnError = Widget Function(RocketException error, Function() reload)?;

class RocketView<T> extends StatefulWidget {
  /// A widget that helps to manage the state of a `RocketModel` and handle the different states of the data.
  ///
  /// The `builder` parameter is a function that takes a `BuildContext` and a `RocketState` and returns a widget tree.
  ///
  /// The `call` parameter is a function that is called to fetch data. It can be a synchronous or asynchronous function.
  ///
  /// The `callType` parameter determines when the `call` function is called. It can be called immediately (`CallType.callAsFuture`), only if the `model` is empty (`CallType.callIfModelEmpty`), or periodically as a stream (`CallType.callAsStream`).
  ///
  /// The `secondsOfStream` parameter is only used if `callType` is `CallType.callAsStream`. It specifies the number of seconds between each call to the `call` function.
  ///
  /// The `loader` parameter is a widget that is displayed while the data is loading. If `null`, no loader is displayed.
  ///
  /// The `model` parameter is a `RocketModel` object that holds the data and state of the widget.
  ///
  /// The `onError` parameter is a function that is called if an error occurs while fetching data. It takes a `RocketException` and a `reload` function as parameters and returns a widget that is displayed instead of the normal builder. The `reload` function can be called to retry fetching data.
  ///
  /// Example usage:
  ///
  /// ```
  /// RocketView(
  ///   model: myModel,
  ///   builder: (context, state) {
  ///     if (state == RocketState.loading) {
  ///       return Center(child: CircularProgressIndicator());
  ///     } else if (state == RocketState.done) {
  ///       return ListView.builder(
  ///         itemCount: myModel.length,
  ///         itemBuilder: (context, index) {
  ///           final item = myModel[index];
  ///           return ListTile(
  ///             title: Text(item.title),
  ///             subtitle: Text(item.body),
  ///             trailing: Checkbox(value: item.completed),
  ///             onTap: () => myModel.updatFields(completed: !item.completed),
  ///           );
  ///         },
  ///       );
  ///     } else {
  ///       return Text('An error occurred!');
  ///     }
  ///   },
  /// //create fetch data method inside model
  ///   fetch: () async => await myModel.fetchData(),
  ///   callType: CallType.callAsFuture,
  ///   onError: (error, reload) => Text('Error: ${error.response}'),
  /// )
  /// ```
  ///
  const RocketView({
    Key? key,
    required this.model,
    required this.builder,
    this.fetch,
    this.callType = CallType.callAsFuture,
    this.onLoading,
    this.onError,
    this.fields,
  }) : super(key: key);

  /// The function that builds the widget tree based on the state.
  final Widget Function(BuildContext, RocketState) builder;

  /// The function that fetches data.
  final dynamic Function()? fetch;

  /// When to call the `call` function.
  final CallType callType;

  /// The widget to display while data is loading, if not defined you need to handle it on `builder` by `state`
  final Widget Function()? onLoading;

  /// The `RocketModel` object that holds the data and state.
  final RocketModel<T> model;

  /// The function to call if an error occurs, if not defined you need to handle it on `builder` by `state`
  final OnError onError;

  /// Specific fields to listen to. If null, the view listens to the entire model.
  final List<String>? fields;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<RocketModel>('RocketModel', model));
  }

  @override
  ViewRocketState createState() => ViewRocketState();
}

/// The state object for the `RocketView` widget.
class ViewRocketState extends State<RocketView> {
  /// The function to call to reload data.
  late Function() reload;

  @override
  void initState() {
    /// Register this listener to the `RocketModel`.
    reload = () {
      widget.model.state = RocketState.loading;
      widget.fetch?.call();
    };
    _registerListeners();

    /// Call the `call` function based on the `callType` parameter.
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

    /// Unregister the old listener and register a new one if the `RocketModel` has changed.
    if (widget.model != oldWidget.model) {
      _unregisterListeners(oldWidget.model);
      _registerListeners();
    }
  }

  @override
  void dispose() {
    /// Unregister this listener.
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

  /// The function to call when a change occurs in the `RocketModel`.
  void _handleChange() {
    setState(() {});
  }

  /// Returns the appropriate widget tree based on the `RocketState`.
  _handleStates() {
    switch (widget.model.state) {
      case RocketState.loading:
        return widget.onLoading != null
            ? widget.onLoading!()
            : const Center(child: CircularProgressIndicator());
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

  @override
  Widget build(BuildContext context) {
    return _handleStates();
  }
}
