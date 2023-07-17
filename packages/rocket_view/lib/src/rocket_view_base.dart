import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rocket_model/rocket_model.dart';

import 'enums.dart';

typedef OnError = Widget Function(RocketException error, Function() reload);

typedef OnLoading = Widget Function(BuildContext);

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
  ///   call: () async => await myModel.fetchData(),
  ///   callType: CallType.callAsFuture,
  ///   onError: (error, reload) => Text('Error: ${error.response}'),
  /// )
  /// ```
  ///
  RocketView({
    Key? key,
    required this.model,
    required this.builder,
    this.call = _myDefaultFunc,
    this.callType = CallType.callAsFuture,
    this.secondsOfStream = 1,
    this.onLoading = _defaultOnLoading,
    this.onError = _defaultOnError,
  }) : super(key: key) {
    /// Call the `call` function based on the `callType` parameter.
    switch (callType) {
      case CallType.callAsFuture:
        call();
        break;
      case CallType.callIfModelEmpty:
        if (!model.existData) {
          call();
        }
        break;
      case CallType.callAsStream:
        call();
        Timer.periodic(Duration(seconds: secondsOfStream), (timer) {
          model.loadingChecking = true;
          call();
          if (!model.hasListeners || model.state != RocketState.done) {
            timer.cancel();
          }
        });
        break;
    }
  }

  /// Default function that does nothing.
  static _myDefaultFunc() {}

  /// Default error widget that displays the error message, status code, response, and a retry button.
  static Widget _defaultOnError(
      RocketException error, dynamic Function() reload) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error.exception.toString()),
          Text("StatusCode : ${error.statusCode.toString()}"),
          Text(
            error.response.toString(),
            style: const TextStyle(overflow: TextOverflow.fade),
          ),
          TextButton(onPressed: reload, child: const Text("Retry"))
        ],
      ),
    );
  }

  static Widget _defaultOnLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// The function that builds the widget tree based on the state.
  final Widget Function(BuildContext) builder;

  /// The function that fetches data.
  final dynamic Function() call;

  /// When to call the `call` function.
  final CallType callType;

  /// Number of seconds between calls if `callType` is `CallType.callAsStream`.
  final int secondsOfStream;

  /// The widget to display while data is loading.
  final OnLoading onLoading;

  /// The `RocketModel` object that holds the data and state.
  final RocketModel<T> model;

  /// The function to call if an error occurs.
  final OnError onError;

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
      widget.call.call();
    };
    widget.model.registerListener(rocketRebuild, _handleChange);
    super.initState();
  }

  @override
  void didUpdateWidget(RocketView oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Unregister the old listener and register a new one if the `RocketModel` has changed.
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(rocketRebuild);
      widget.model.registerListener(rocketRebuild, _handleChange);

      /// Unregister the old listeners and register new ones if the `RocketModel` is a list.
      if (oldWidget.model.all != null) {
        for (var e in oldWidget.model.all!) {
          e.removeListener(rocketRebuild);
        }
      }
      if (widget.model.all != null) {
        for (var e in widget.model.all!) {
          e.registerListener(rocketRebuild, _handleChange);
        }
      }
    }
  }

  @override
  void dispose() {
    /// Unregister this listener and all the listeners for the `RocketModel` if it is a list.
    widget.model.removeListener(rocketRebuild);
    if (widget.model.all != null) {
      for (var e in widget.model.all!) {
        e.removeListener(rocketRebuild);
      }
    }
    super.dispose();
  }

  /// The function to call when a change occurs in the `RocketModel`.
  void _handleChange() {
    if (widget.model.state == RocketState.done) {
      if (widget.model.all != null) {
        for (var e in widget.model.all!) {
          if (!e.keyHasListeners(rocketRebuild)) {
            e.registerListener(rocketRebuild, _handleChange);
          }
        }
      }
    }
    setState(() {});
  }

  /// Returns the appropriate widget tree based on the `RocketState`.
  _handleStates() {
    switch (widget.model.state) {
      case RocketState.loading:
        return widget.onLoading(context);
      case RocketState.done:
        return widget.builder(context);
      case RocketState.failed:
        return widget.onError(widget.model.exception, reload);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Return the appropriate widget tree based on the `RocketState`.
    return _handleStates();
  }
}
