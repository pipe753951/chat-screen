import 'package:flutter/material.dart';

class ChatInputProvider extends ChangeNotifier {
  // Text controller and node.
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  // isTextFieldEmpty boolean (editing outside of this class is forbidden)
  bool _isTextFieldEmpty = true;
  bool get isTextFieldEmpty => _isTextFieldEmpty;

  final ValueChanged<String> onValue;

  ChatInputProvider(this.onValue) {
    textController.addListener(() {
      final bool isTextFieldActuallyEmpty = textController.text.trim().isEmpty;
      if (isTextFieldActuallyEmpty != _isTextFieldEmpty) {
        _isTextFieldEmpty = isTextFieldActuallyEmpty;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  /// On submit Text Field.
  void onFieldSubmitted(String value) {
    textController.clear();
    onValue(value);
  }
}
