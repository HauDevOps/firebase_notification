import 'package:flutter/material.dart';

@immutable
class Messages {
  final String title;
  final String body;
  final String imageLink;

  const Messages({
    @required this.title,
    @required this.body,
    @required this.imageLink,
  });
}