import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yes_no_app/presentation/providers/providers.dart';

class TextMessageField extends StatelessWidget {
  const TextMessageField({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatTextInputProvider chatTextInputProvider = context
        .watch<ChatTextInputProvider>();

    final UnderlineInputBorder outlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(50),
    );

    final InputDecoration inputDecoration = InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      hintText: 'Message',
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
    );

    return TextFormField(
      focusNode: chatTextInputProvider.focusNode,
      controller: chatTextInputProvider.textController,
      decoration: inputDecoration,
      onFieldSubmitted: (value) {
        chatTextInputProvider.onFieldSubmitted(value);
      },
    );
  }
}
