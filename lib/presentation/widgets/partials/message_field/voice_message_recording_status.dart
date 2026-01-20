import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

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
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),

      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _voiceIconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return FadeInRight(
      duration: const Duration(milliseconds: 200),
      from: 50,
      child: Row(
        children: [
          SizedBox.square(
            dimension: 50,
            child: FadeTransition(
              opacity: _voiceIconAnimationController,
              child: Icon(Icons.mic_rounded, color: colorScheme.primary),
            ),
          ),
          Text('00:01', style: TextStyle(fontSize: 20)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.arrow_back_ios_new_rounded, size: 20,),
                Text('Desliza para cancelar', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 24,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
