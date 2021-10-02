import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mc/src/mc_model.dart';

/// call طريقة استدعاء دالة

enum CallType {
  /// يتم استدعاء الدالة يشكل متكرر
  callAsStream,

  /// يتم استدعاء الدالة مرة واحدة
  callAsFuture,

  /// يتم استدعاء الدالة عندما يكون النموذج فارغ
  callIfModelEmpty,
}

class McView extends StatefulWidget {
  /// [McView]
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
  ///يمكنك تحديد عدد الثواني من اجل تجديد البيانات callAsStream في حالة اختيار
  ///
  ///[retryText]
  ///
  ///النص الذي سيظهر في الور في حالة وجود خطأ
  ///
  ///[styleButton]
  ///
  ///تصميم الزر يمكنك التحكم من حلاله في الألوان ...
  ///
  ///[showExceptionDetails]
  ///
  ///تفعيل او الغاء ظهور تفاصيل الخطأ
  ///
  McView(
      {Key? key,
      required this.model,
      required this.builder,
      this.call = _myDefaultFunc,
      this.callType = CallType.callAsFuture,
      this.secondsOfStream = 1,
      this.loader,
      this.retryText = "Failed, retry",
      this.styleButton,
      this.showExceptionDetails = false}) {
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
          model.loadingChecking(true);
          call();
          if (!model.hasListener()) timer.cancel();
        });
        break;
    }
  }

  static _myDefaultFunc() {}
  final Widget Function() builder;
  final dynamic Function() call;
  final CallType callType;
  final int secondsOfStream;
  final Widget? loader;
  final McModel model;
  final String retryText;
  final ButtonStyle? styleButton;
  final bool showExceptionDetails;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Listenable>('McModel', model));
  }

  @override
  _McViewState createState() => _McViewState();
}

class _McViewState extends State<McView> {
  @override
  void initState() {
    super.initState();
    widget.model.addListener(_handleChange);
  }

  @override
  void didUpdateWidget(McView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_handleChange);
      widget.model.addListener(_handleChange);
    }
  }

  @override
  void dispose() {
    widget.model.removeListener(_handleChange);
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
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.2,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          //TODO: make more customizible
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  child: Text(widget.retryText),
                  style: widget.styleButton,
                  onPressed: () {
                    widget.model.setFailed(false);
                    widget.model.load(true);
                    widget.call();
                  }),
              widget.showExceptionDetails
                  ? ElevatedButton(
                      child: Text("show Details"),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                   widget.model.exception.split(":")[0] +
                                      " " +
                                    widget.model.statusCode.keys.first
                                          .toString(),
                                ),
                                content: Text(
                                  widget.model.exception +
                                      "\n- " +
                                       widget.model.statusCode.values.first.toString(),
                                ),
                              );
                            });
                      })
                  : const SizedBox(),
            ],
          ),
        ),
      );
    } else {
      return widget.model.loading
          ? Center(child: widget.loader ?? CircularProgressIndicator())
          : widget.builder();
    }
  }
}
