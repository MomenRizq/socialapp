import 'package:flutter/material.dart';

void showSnackBar(BuildContext ctx ,{String? mesaage , Color? color }) {
  ScaffoldMessenger.of(ctx)
      .showSnackBar(SnackBar(
    backgroundColor: color,
    content: Text('$mesaage'),
    duration: Duration(seconds: 5),
  ));
}