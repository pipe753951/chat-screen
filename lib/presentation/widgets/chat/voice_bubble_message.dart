import 'package:flutter/material.dart';
import 'package:yes_no_app/domain/domain.dart';

class VoiceBubbleMessage extends StatelessWidget {
  final VoiceMessage voiceMessage;

  const VoiceBubbleMessage({super.key, required this.voiceMessage});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: (voiceMessage.fromWho == FromWho.me)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          width: size.width,
          height: 65,
          constraints: BoxConstraints(maxWidth: 250),
          decoration: BoxDecoration(
            color: (voiceMessage.fromWho == FromWho.me)
                ? colorScheme.primary
                : colorScheme.secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              spacing: 8,
              textDirection: (voiceMessage.fromWho == FromWho.me)
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              children: [
                SizedBox.square(
                  dimension: 45,
                  child: CircleAvatar(
                    // Photo by Khanh Do - Unsplash
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1764072565527-a079ac59853d?ixlib=rb-4.1.0&q=85&fm=jpg&crop=entropy&cs=srgb&w=640',
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.play_arrow_rounded),
                        iconSize: 35,
                        color: colorScheme.onPrimary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}
