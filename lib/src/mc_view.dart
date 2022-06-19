import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'mc_model.dart';
import 'mc_constants.dart';
import 'mc_exception.dart';
import 'mc_llistenable.dart';

typedef OnError = Widget Function(RocketException error, Function() reload);

class RocketView<T> extends StatefulWidget {
  /// [RocketView]
  ///
  /// انشاء البناء الخاص باعادة بناء المحتويات الخاصة به.
  ///
  ///
  ///[model]
  ///
  ///النموذج الذي يحتوي على البيانات المراد تجديدها
  ///
  ///
  ///[builder]
  ///
  ///البناء دالة ترجع المحتويات المراد اعادة بناءها لتغيير قيمها
  ///
  ///
  ///[loader]
  ///
  ///الجزء الخاص بانتظار تحميل البيانات و هو اختياري
  ///
  ///[call]
  ///
  ///الدالة الخاصة بطلب البيانات من لخادم
  ///
  ///
  ///[callType]
  ///
  ///طريقة استدعاء الدالة
  ///
  ///[secondsOfStream]
  ///
  /// في حالة اختيار [call] عدد الثواني لاعادة استدعاء دالة
  ///[CallType.callAsStream]
  ///
  ///[onError]
  ///لبناء الواجهة الخاصة باظهار اي خطأ ويتم تمرير كائن يحمل الاخطأ التي حدثت
  ///

  RocketView({
    Key? key,
    required this.model,
    required this.builder,
    this.call = _myDefaultFunc,
    this.callType = CallType.callAsFuture,
    this.secondsOfStream = 1,
    this.loader,
    this.onError = _defaultOnError,
  }) : super(key: key) {
    ///if (call == _myDefaultFunc) model.state =  RocketState.done;

    /// call التحقق من طريقة الاستدعاء لدالة
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

  static _myDefaultFunc() {}

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

  ///البناء دالة ترجع المحتويات المراد اعادة بناءها لتغيير قيمتها
  final Widget Function(BuildContext) builder;

  ///الدالة الخاصة بطلب البيانات من لخادم
  final dynamic Function() call;

  ///[call] طريقة استدعاء دالة
  final CallType callType;

  ///في حالة اختيار [call] عدد الثواني لاعادة استدعاء دالة
  ///[CallType.callAsStream]
  final int secondsOfStream;

  ///الجزء الخاص بانتظار تحميل البيانات و هو اختياري
  final Widget? loader;

  ///النموذج الذي يحتوي على البيانات المراد تجديدها
  final RocketModel<T> model;

  ///لبناء الواجهة الخاصة باظهار اي خطأ ويتم تمرير كائن يحمل الاخطأ التي حدثت
  final OnError onError;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<RocketListenable>('McModel', model));
  }

  @override
  ViewRocketState createState() => ViewRocketState();
}

class ViewRocketState extends State<RocketView> {
  late Function() reload;
  @override
  void initState() {
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
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(rocketRebuild);
      widget.model.registerListener(rocketRebuild, _handleChange);
      if (oldWidget.model.multi != null) {
        for (var e in oldWidget.model.multi!) {
          e.removeListener(rocketRebuild);
        }
      }
      if (widget.model.multi != null) {
        for (var e in widget.model.multi!) {
          e.registerListener(rocketRebuild, _handleChange);
        }
      }
    }
  }

  @override
  void dispose() {
    widget.model.removeListener(rocketRebuild);
    super.dispose();
  }

  void _handleChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.model.state) {
      case RocketState.loading:
        return Center(
            child: widget.loader ?? const CircularProgressIndicator());
      case RocketState.done:
        if (widget.model.multi != null) {
          for (var e in widget.model.multi!) {
            if (!e.keyHasListeners(rocketRebuild)) {
              e.registerListener(rocketRebuild, _handleChange);
            }
          }
        }
        return widget.builder(context);
      case RocketState.failed:
        return widget.onError(widget.model.exception, reload);
    }
  }
}
