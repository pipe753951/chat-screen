import 'package:flutter/material.dart';
import 'package:yes_no_app/domain/domain.dart';

class TextMessageBubble extends StatelessWidget {
  final TextMessage message;

  const TextMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: (message.fromWho == FromWho.me)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: (message.fromWho == FromWho.me)
                ? colors.primary
                : colors.secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              message.text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}
