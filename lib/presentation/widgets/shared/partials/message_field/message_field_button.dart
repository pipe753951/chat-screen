import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:yes_no_app/presentation/providers/providers.dart';

class MessageFieldButton extends StatelessWidget {
  const MessageFieldButton({super.key});

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
    final ChatTextInputProvider chatTextInputProvider = context
        .read<ChatTextInputProvider>();

    // If there is any text, send message
    if (!chatTextInputProvider.isTextFieldEmpty) {
      final String textFormFieldText = chatTextInputProvider.textController.text;
      chatTextInputProvider.onFieldSubmitted(textFormFieldText);
    }
    // TODO: Start recording by tap button
  }

  void onLongPress(BuildContext context) {
    final ChatTextInputProvider chatTextInputProvider = context
        .read<ChatTextInputProvider>();
    final ChatVoiceRecorderProvider chatVoiceRecorderProvider = context
        .read<ChatVoiceRecorderProvider>();

    // If there isn't any text, start recording.
    if (chatTextInputProvider.isTextFieldEmpty) {
      try {
        chatVoiceRecorderProvider.startRecording(
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
    final ChatVoiceRecorderProvider chatVoiceRecorderProvider = context
        .read<ChatVoiceRecorderProvider>();

    // Stop recording
    chatVoiceRecorderProvider.stopRecording();
  }

  @override
  Widget build(BuildContext context) {
    final ChatVoiceRecorderProvider chatVoiceRecorderProvider = context
        .watch<ChatVoiceRecorderProvider>();

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SizedBox.square(
      dimension: 50,
      child: AnimatedScale(
        scale: chatVoiceRecorderProvider.isRecording ? 2 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Material(
          borderRadius: BorderRadius.circular(25),
          color: colorScheme.primary,
          child: GestureDetector(
            onLongPressStart: (_) => onLongPress(context),
            onLongPressMoveUpdate: (details) {
              chatVoiceRecorderProvider.updateDragOffset(details.localPosition.dx);
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
    final ChatTextInputProvider chatTextInputProvider = context
        .watch<ChatTextInputProvider>();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: chatTextInputProvider.isTextFieldEmpty
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
