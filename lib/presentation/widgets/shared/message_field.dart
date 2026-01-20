import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yes_no_app/presentation/providers/message_field_provider.dart';
import 'package:yes_no_app/presentation/widgets/widgets.dart' show MessageFieldButton;

class MessageField extends StatelessWidget {
  final ValueChanged<String> onValue;

  const MessageField({super.key, required this.onValue});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MessageFieldProvider(onValue),
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(vertical: 8),
        child: Row(
          spacing: 8,
          children: [
            Expanded(child: MessageFieldBox()),
            MessageFieldButton(onValue: onValue),
          ],
        ),
      ),
    );
  }
}


class MessageFieldBox extends StatelessWidget {
  const MessageFieldBox({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final BoxDecoration boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: colorScheme.surfaceContainerHighest,
    );

    return SizedBox(
      height: 50,
      child: DecoratedBox(
        decoration: boxDecoration,
        child: Center(child: TextMessageField()),
      ),
    );
  }
}

class TextMessageField extends StatelessWidget {
  const TextMessageField({super.key});

  @override
  Widget build(BuildContext context) {
    final MessageFieldProvider messageFieldProvider = context
        .watch<MessageFieldProvider>();

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
      onTapOutside: (_) {
        messageFieldProvider.focusNode.unfocus();
      },
      focusNode: messageFieldProvider.focusNode,
      controller: messageFieldProvider.textController,
      decoration: inputDecoration,
      onFieldSubmitted: (value) {
        messageFieldProvider.onFieldSubmitted(value: value, autoFocus: false);
      },
    );
  }
}
