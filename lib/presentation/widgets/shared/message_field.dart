import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yes_no_app/presentation/providers/providers.dart';
import 'package:yes_no_app/presentation/widgets/widgets.dart';

class MessageField extends StatelessWidget {
  final ValueChanged<String> onValue;

  const MessageField({super.key, required this.onValue});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatInputProvider(onValue)),
        ChangeNotifierProvider(create: (_) => VoiceMessageProvider())
      ],
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(vertical: 8),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(child: MessageFieldBox()),
                const SizedBox(width: 58),
              ],
            ),
            Positioned(
              right: 0,
              child: MessageFieldButton(onValue: onValue)
            ),
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
    final VoiceMessageProvider voiceMessageProvider = context
        .watch<VoiceMessageProvider>();

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
          child: voiceMessageProvider.isRecording
              ? VoiceMessageRecordingStatus()
              : TextMessageField(),
        ),
      ),
    );
  }
}
