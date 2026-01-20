import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:yes_no_app/presentation/providers/providers.dart';

class MessageFieldButton extends StatelessWidget {
  const MessageFieldButton({super.key, required this.onValue});

  final ValueChanged<String> onValue;

  void openPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permiso denegado'),
        content: Text(
          'No podemos acceder al micrófono. Para grabar audio, permite el acceso al micrófono en ajustes.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Ajustes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void onTap(BuildContext context) {
    final ChatInputProvider messageFieldProvider = context
        .read<ChatInputProvider>();

    // If there is any text, send message
    if (!messageFieldProvider.isTextFieldEmpty) {
      final String textFormFieldText = messageFieldProvider.textController.text;
      messageFieldProvider.onFieldSubmitted(textFormFieldText);
    }
    // TODO: Start recording by tap button
  }

  void onLongPress(BuildContext context) {
    final ChatInputProvider messageFieldProvider = context
        .read<ChatInputProvider>();
    final VoiceMessageProvider voiceMessageProvider = context
        .read<VoiceMessageProvider>();

    // If there isn't any text, start recording.
    if (messageFieldProvider.isTextFieldEmpty) {
      try {
        voiceMessageProvider.startRecording(
          callOnPermissionDenied: () {
            openPermissionDeniedDialog(context);
          },
        );
      } catch (e) {
        print('Hubo un error');
      }
    }
  }

  void onLongPressUp(BuildContext context) {
    // Access provider
    final VoiceMessageProvider voiceMessageProvider = context
        .read<VoiceMessageProvider>();

    // Stop recording
    voiceMessageProvider.stopRecording();
  }

  @override
  Widget build(BuildContext context) {
    final VoiceMessageProvider voiceMessageProvider = context
        .watch<VoiceMessageProvider>();

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SizedBox.square(
      dimension: 50,
      child: AnimatedScale(
        scale: voiceMessageProvider.isRecording ? 2 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Material(
          borderRadius: BorderRadius.circular(25),
          color: colorScheme.primary,
          child: GestureDetector(
            onLongPressStart: (_) => onLongPress(context),
            onLongPressMoveUpdate: (details) {
              voiceMessageProvider.updateDragOffset(details.localPosition.dx);
            },
            onLongPressEnd: (_) => onLongPressUp(context),
            
            // Inkwell is used for effects and tap callback
            child: InkWell(
              onTap: () => onTap(context),
              borderRadius: BorderRadius.circular(25),

              child: _MessageButtonIcon(),
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageButtonIcon extends StatelessWidget {
  const _MessageButtonIcon();

  @override
  Widget build(BuildContext context) {
    final ChatInputProvider messageFieldProvider = context
        .watch<ChatInputProvider>();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: messageFieldProvider.isTextFieldEmpty
          ? Icon(
              Icons.mic_rounded,
              key: ValueKey('mic_icon'),
              color: Colors.white,
            )
          : Icon(
              Icons.send_rounded,
              key: ValueKey('send_icon'),
              color: Colors.white,
            ),
    );
  }
}
