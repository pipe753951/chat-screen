import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yes_no_app/presentation/providers/message_field_provider.dart';

class MessageFieldButton extends StatelessWidget {
  const MessageFieldButton({super.key, required this.onValue});

  final ValueChanged<String> onValue;

  void openPermissionDeniedDialog(BuildContext context) {
    final openApplicationSettings = context
        .read<MessageFieldProvider>()
        .openApplicationSettings;

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
              openApplicationSettings();
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

  @override
  Widget build(BuildContext context) {
    final MessageFieldProvider messageFieldProvider = context
        .watch<MessageFieldProvider>();

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SizedBox.square(
      dimension: 50,
      child: AnimatedScale(
        scale: messageFieldProvider.isRecording ? 2 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Material(
          borderRadius: BorderRadius.circular(25),
          color: colorScheme.primary,
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            child: _MessageButtonIcon(),

            onTap: () {
              // If there is any text, send message
              if (!messageFieldProvider.isTextFieldEmpty) {
                final String textFormFieldText =
                    messageFieldProvider.textController.text;
                messageFieldProvider.onFieldSubmitted(textFormFieldText);
              }
              // TODO: Start recording by tap button
            },
            onLongPress: () {
              // If there isn't any text, start recording.
              if (messageFieldProvider.isTextFieldEmpty) {
                try {
                  messageFieldProvider.startRecording(
                    callOnPermissionDenied: () {
                      openPermissionDeniedDialog(context);
                    },
                  );
                } catch (e) {
                  print('Hubo un error');
                }
              }
            },
            onLongPressUp: () {
              // If there isn't any text, stop.
              if (messageFieldProvider.isTextFieldEmpty) {
                messageFieldProvider.stopRecording();
              }
            },
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
    final MessageFieldProvider messageFieldProvider = context
        .watch<MessageFieldProvider>();

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
