import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rocket/flutter_rocket.dart';

class WidgetStates {
  static Widget onLoading(BuildContext context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      );
  static Widget onError(RocketException exception, Function() reload) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(exception.exception),
          if (exception.statusCode != HttpStatus.ok) ...[
            Text(exception.response),
            Text(Rocket.get(rocketRequestKey)
                .msgByStatusCode(exception.statusCode))
          ],
          TextButton(onPressed: reload, child: const Text("retry"))
        ],
      ),
    );
  }
}
