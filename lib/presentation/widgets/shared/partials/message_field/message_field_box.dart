import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yes_no_app/presentation/providers/providers.dart';
import 'package:yes_no_app/presentation/widgets/shared/partials/shared_partials.dart';

class MessageFieldBox extends StatelessWidget {
  const MessageFieldBox({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatVoiceRecorderProvider chatVoiceRecorderProvider = context
        .watch<ChatVoiceRecorderProvider>();

    // App color scheme
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    // Field decoration
    final BoxDecoration boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: colorScheme.surfaceContainerHighest,
    );

    // Rendered widget
    return SizedBox(
      height: 50,
      child: DecoratedBox(
        decoration: boxDecoration,
        // Animated field content (text field / recording status)
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          // Field content (text field / recording status)
          child: chatVoiceRecorderProvider.isRecording
              ? VoiceMessageRecordingStatus()
              : TextMessageField(),
        ),
      ),
    );
  }
}
