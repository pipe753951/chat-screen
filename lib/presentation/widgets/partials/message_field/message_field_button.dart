import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yes_no_app/presentation/providers/message_field_provider.dart';

class MessageFieldButton extends StatelessWidget {
  const MessageFieldButton({super.key, required this.onValue});

  final ValueChanged<String> onValue;

  @override
  Widget build(BuildContext context) {
    final MessageFieldProvider messageFieldProvider = context
        .watch<MessageFieldProvider>();
    final TextEditingController textController =
        messageFieldProvider.textController;

    return SizedBox.square(
      dimension: 50,
      child: IconButton.filled(
        onPressed: () => messageFieldProvider.onFieldSubmitted(
          value: textController.value.text,
        ),
        icon: _MessageButtonIcon(),
      ),
    );
  }
}

class _MessageButtonIcon extends StatelessWidget {
  const _MessageButtonIcon();

  @override
  Widget build(BuildContext context) {
    final MessageFieldProvider messageFieldProvider = context
        .watch<MessageFieldProvider>();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: messageFieldProvider.isTextFieldEmpty
          ? Icon(Icons.keyboard_voice, key: ValueKey('mic_icon'))
          : Icon(Icons.send_rounded, key: ValueKey('send_icon')),
    );
  }
}
