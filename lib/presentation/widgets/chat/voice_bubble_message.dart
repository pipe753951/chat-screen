import 'package:audio_waveforms/audio_waveforms.dart';
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
          constraints: BoxConstraints(maxWidth: 300),
          decoration: BoxDecoration(
            color: (voiceMessage.fromWho == FromWho.me)
                ? colorScheme.primary
                : colorScheme.secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _VoiceBubbleMessageLayout(voiceMessage: voiceMessage),
          ),
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}

class _VoiceBubbleMessageLayout extends StatefulWidget {
  const _VoiceBubbleMessageLayout({required this.voiceMessage});

  final VoiceMessage voiceMessage;

  @override
  State<_VoiceBubbleMessageLayout> createState() =>
      _VoiceBubbleMessageLayoutState();
}

class _VoiceBubbleMessageLayoutState extends State<_VoiceBubbleMessageLayout> {
  final PlayerController playerController = PlayerController();
  final audioPlayerSlideStyle = PlayerWaveStyle(
    fixedWaveColor: Colors.grey, // Color del audio que falta por oír
    liveWaveColor: Colors.blue, // Color del audio ya reproducido
    spacing: 5, // Espacio entre barras
    waveThickness: 3, // Grosor de cada barra
  );

  @override
  void initState() {
    prepareAudio();
    super.initState();
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  void prepareAudio() async {
    await playerController.preparePlayer(
      path: widget.voiceMessage.location,
      shouldExtractWaveform: true,
      noOfSamples: audioPlayerSlideStyle.getSamplesForWidth(150),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      spacing: 8,
      textDirection: (widget.voiceMessage.fromWho == FromWho.me)
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
            spacing: 8,
            children: [
              IconButton(
                onPressed: () {
                  playerController.startPlayer();
                },
                icon: Icon(Icons.play_arrow_rounded),
                iconSize: 35,
                color: colorScheme.onPrimary,
              ),
              Expanded(
                child: AudioFileWaveforms(
                  size: Size(150, 40),
                  playerController: playerController,
                  enableSeekGesture: true,
                  waveformType: WaveformType.fitWidth,
                  playerWaveStyle: audioPlayerSlideStyle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
