import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yes_no_app/presentation/providers/message_field_provider.dart';
import 'package:yes_no_app/presentation/widgets/widgets.dart'
    show MessageFieldButton;

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
    final MessageFieldProvider messageFieldProvider = context
        .watch<MessageFieldProvider>();

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final BoxDecoration boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: colorScheme.surfaceContainerHighest,
    );

    return SizedBox(
      height: 50,
      child: DecoratedBox(
        decoration: boxDecoration,
        // TODO: Use AnimatedSwitcher
        // child: AnimatedSwitcher(
        //   duration: const Duration(milliseconds: 200),
        //   transitionBuilder: (Widget child, Animation<double> animation) {
        //     return FadeTransition(opacity: animation, child: child);
        //   },
        //   child: messageFieldProvider.isRecording
        //       ? VoiceMessageRecordingStatus()
        //       : TextMessageField(),
        // ),
        child: VoiceMessageRecordingStatus(),
      ),
    );
  }
}

class VoiceMessageRecordingStatus extends StatefulWidget {
  const VoiceMessageRecordingStatus({super.key});

  @override
  State<VoiceMessageRecordingStatus> createState() =>
      _VoiceMessageRecordingStatusState();
}

class _VoiceMessageRecordingStatusState
    extends State<VoiceMessageRecordingStatus>
    with SingleTickerProviderStateMixin {
  late final AnimationController _voiceIconAnimationController;

  @override
  void initState() {
    super.initState();

    // Start _voiceIconAnimationController
    _voiceIconAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _voiceIconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FadeTransition(
          opacity: _voiceIconAnimationController,
          child: const Icon(Icons.mic_rounded),
        ),
        Text('2'),
      ],
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
      focusNode: messageFieldProvider.focusNode,
      controller: messageFieldProvider.textController,
      decoration: inputDecoration,
      onFieldSubmitted: (value) {
        messageFieldProvider.onFieldSubmitted(value);
      },
    );
  }
}
