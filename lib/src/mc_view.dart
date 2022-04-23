import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'mc_model.dart';
import 'mc_constants.dart';
import 'mc_exception.dart';
import 'mc_llistenable.dart';

typedef OnError = Widget Function(RocketException error, Function() reload);

enum CallType {
  /// يتم استدعاء الدالة يشكل متكرر
  callAsStream,

  /// يتم استدعاء الدالة مرة واحدة
  callAsFuture,

  /// يتم استدعاء الدالة عندما يكون النموذج فارغ
  callIfModelEmpty,
}

class RocketView extends StatefulWidget {
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
  }) {
    model.load(true);

    /// call التحقق من طريقة الاستدعاء لدالة
    switch (callType) {
      case CallType.callAsFuture:
        Future.value(call()).whenComplete(() => model.load(false));
        break;
      case CallType.callIfModelEmpty:
        if (!model.existData) {
          Future.value(call()).whenComplete(() => model.load(false));
        }
        break;
      case CallType.callAsStream:
        Future.value(call()).whenComplete(() => model.load(false));
        Timer.periodic(Duration(seconds: secondsOfStream), (timer) {
          model.loadingChecking(true);
          call();
          if (!model.hasListener()) timer.cancel();
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
            style: TextStyle(overflow: TextOverflow.fade),
          ),
          TextButton(onPressed: reload, child: Text("Retry"))
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
  final RocketModel model;

  ///لبناء الواجهة الخاصة باظهار اي خطأ ويتم تمرير كائن يحمل الاخطأ التي حدثت
  final OnError onError;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<RocketListenable>('McModel', model));
  }

  @override
  _ViewRocketState createState() => _ViewRocketState();
}

class _ViewRocketState extends State<RocketView> {
  late Function() reload;
  @override
  void initState() {
    reload = () {
      widget.model.setFailed(false);
      widget.model.load(true);
      widget.call.call();
    };
    widget.model.registerListener(rebuild, _handleChange);
    super.initState();
  }

  @override
  void didUpdateWidget(RocketView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(rebuild);
      widget.model.registerListener(rebuild, _handleChange);
    }
  }

  @override
  void dispose() {
    widget.model.removeListener(rebuild);
    super.dispose();
  }

  void _handleChange() {
    setState(() {
      // The listenable's state is our build state, and it changed already.
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.failed) {
      return widget.onError != null
          ? widget.onError!(widget.model.exception, reload)
          : const SizedBox();
    } else {
      return widget.model.loading
          ? Center(child: widget.loader ?? CircularProgressIndicator())
          : widget.builder(context);
    }
  }
}
