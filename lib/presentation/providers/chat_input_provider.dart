import 'package:flutter/material.dart';
import 'package:yes_no_app/domain/domain.dart';

typedef OnSendTextMessage = Function(TextMessage);

class ChatInputProvider extends ChangeNotifier {
  // Text controller and node.
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  // isTextFieldEmpty boolean (editing outside of this class is forbidden)
  bool _isTextFieldEmpty = true;
  bool get isTextFieldEmpty => _isTextFieldEmpty;

  final OnSendTextMessage onSendTextMessage;

  ChatInputProvider(this.onSendTextMessage) {
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
    _returnTextMessage(value);
  }

  /// Send a new [TextMessage] to proccess as widget MessageField has indicated.
  void _returnTextMessage(String text) {
    final TextMessage newTextMessage = TextMessage(
      fromWho: FromWho.me,
      text: text,
    );

    onSendTextMessage(newTextMessage);
  }
}
