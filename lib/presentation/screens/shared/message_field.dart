import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yes_no_app/presentation/providers/message_field_provider.dart';

class MessageField extends StatelessWidget {
  final ValueChanged<String> onValue;

  const MessageField({super.key, required this.onValue});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MessageFieldProvider(),
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(vertical: 8),
        child: Row(
          spacing: 8,
          children: [
            Expanded(child: MessageFieldBox(onValue: onValue)),
            _MessageButton(onValue: onValue),
          ],
        ),
      ),
    );
  }
}

class _MessageButton extends StatelessWidget {
  const _MessageButton({required this.onValue});

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
        onPressed: () {
          final textValue = textController.value.text;
          textController.clear();
          onValue(textValue);
        },
        icon: (textController.value == TextEditingValue.empty)
            ? Icon(Icons.keyboard_voice)
            : Icon(Icons.send_rounded),
      ),
    );
  }
}

class MessageFieldBox extends StatelessWidget {
  final ValueChanged<String> onValue;

  const MessageFieldBox({super.key, required this.onValue});

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
        child: Center(child: TextMessageField(onValue: onValue)),
      ),
    );
  }
}

class TextMessageField extends StatelessWidget {
  final ValueChanged<String> onValue;

  const TextMessageField({super.key, required this.onValue});

  @override
  Widget build(BuildContext context) {
    final MessageFieldProvider messageFieldProvider = context
        .watch<MessageFieldProvider>();
    final TextEditingController textController =
        messageFieldProvider.textController;
    final FocusNode focusNode = messageFieldProvider.focusNode;

    final outlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(50),
    );

    final inputDecoration = InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      hintText: 'Message',
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
    );

    return TextFormField(
      onTapOutside: (event) {
        focusNode.unfocus();
      },
      focusNode: focusNode,
      controller: textController,
      decoration: inputDecoration,
      onFieldSubmitted: (value) {
        textController.clear();
        focusNode.requestFocus();
        onValue(value);
      },
    );
  }
}
