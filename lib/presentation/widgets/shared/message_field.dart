import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yes_no_app/presentation/providers/providers.dart';
import 'package:yes_no_app/presentation/widgets/shared/partials/shared_partials.dart';

class MessageField extends StatelessWidget {
  final OnSendTextMessage onSendTextMessage;
  final OnSendVoiceMessage onSendVoiceMessage;

  const MessageField({
    super.key,
    required this.onSendTextMessage,
    required this.onSendVoiceMessage,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatInputProvider(onSendTextMessage),
        ),
        ChangeNotifierProvider(
          create: (_) => VoiceMessageProvider(onSendVoiceMessage),
        ),
      ],
      child: _MessageFieldLayout(),
    );
  }
}

class _MessageFieldLayout extends StatelessWidget {
  const _MessageFieldLayout();

  @override
  Widget build(BuildContext context) {
    final VoiceMessageProvider voiceMessageProvider = context.watch();

    return Padding(
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
            right: -voiceMessageProvider.dragOffset,
            child: MessageFieldButton(),
          ),
        ],
      ),
    );
  }
}
