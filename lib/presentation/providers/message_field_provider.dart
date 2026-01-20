import 'package:flutter/material.dart';

class MessageFieldProvider extends ChangeNotifier {
  final ValueChanged<String> onValue;
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool isTextFieldEmpty = true;

  MessageFieldProvider(this.onValue) {
    textController.addListener(_onTextFieldChanged);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _onTextFieldChanged() {
    final bool isTextFieldActuallyEmpty = textController.text.trim().isEmpty;
    if (isTextFieldActuallyEmpty != isTextFieldEmpty) {
      isTextFieldEmpty = isTextFieldActuallyEmpty;
      notifyListeners();
    }
  }

  void onFieldSubmitted({required String value, bool autoFocus = false}) {
    textController.clear();
    if (autoFocus) focusNode.requestFocus();

    onValue(value);
  }
}
