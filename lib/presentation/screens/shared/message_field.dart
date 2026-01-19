import 'package:flutter/material.dart';

class MessageField extends StatelessWidget {
  final ValueChanged<String> onValue;

  const MessageField({super.key, required this.onValue});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final FocusNode focusNode = FocusNode();

    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: MessageFieldBox(
            focusNode: focusNode,
            textController: textController,
            onValue: onValue,
          ),
        ),
        _MessageButton(textController: textController, onValue: onValue),
      ],
    );
  }
}

class _MessageButton extends StatelessWidget {
  const _MessageButton({
    required this.textController,
    required this.onValue,
  });

  final TextEditingController textController;
  final ValueChanged<String> onValue;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return SizedBox.square(
      dimension: 50,
      child: IconButton.filled(
        onPressed: () {
          final textValue = textController.value.text;
          textController.clear();
          onValue(textValue);
        },
        // icon: Icon(Icons.keyboard_voice),
        icon: Icon(Icons.send_rounded),
      ),
    );
  }
}

class MessageFieldBox extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController textController;
  final ValueChanged<String> onValue;

  const MessageFieldBox({
    super.key,
    required this.focusNode,
    required this.textController,
    required this.onValue,
  });

  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(50),
    );

    final inputDecoration = InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      hintText: 'Message',
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      filled: true,
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
