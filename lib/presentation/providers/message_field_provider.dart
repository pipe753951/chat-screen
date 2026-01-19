import 'package:flutter/material.dart';

class MessageFieldProvider extends ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
}
