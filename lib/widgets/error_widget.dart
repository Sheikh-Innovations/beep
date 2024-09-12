import 'package:flutter/material.dart';

import 'package:beep/utils/error_reporter.dart';

class beepErrorWidget extends StatefulWidget {
  final FlutterErrorDetails details;
  const beepErrorWidget(this.details, {super.key});

  @override
  State<beepErrorWidget> createState() => _beepErrorWidgetState();
}

class _beepErrorWidgetState extends State<beepErrorWidget> {
  static final Set<String> knownExceptions = {};
  @override
  void initState() {
    super.initState();

    if (knownExceptions.contains(widget.details.exception.toString())) {
      return;
    }
    knownExceptions.add(widget.details.exception.toString());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ErrorReporter(context, 'Error Widget').onErrorCallback(
        widget.details.exception,
        widget.details.stack,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.orange,
      child: Placeholder(
        child: Center(
          child: Material(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
