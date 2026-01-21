import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:yes_no_app/domain/domain.dart';

class ImageBubbleMessage extends StatelessWidget {
  final ImageMessage imageMessage;

  const ImageBubbleMessage({super.key, required this.imageMessage});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Align(
      alignment: (imageMessage.fromWho == FromWho.me)
          ? AlignmentGeometry.centerRight
          : AlignmentGeometry.centerLeft,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          imageMessage.imageUrl,
          width: size.width * 0.7,
          height: 150,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return FadeIn(
                duration: const Duration(milliseconds: 500),
                child: child,
              );
            }
        
            return Container(
              color: colorScheme.surfaceContainerHigh,
              width: size.width * 0.7,
              height: 150,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
