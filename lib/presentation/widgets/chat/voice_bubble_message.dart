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

class _VoiceBubbleMessageLayout extends StatelessWidget {
  const _VoiceBubbleMessageLayout({required this.voiceMessage});

  final VoiceMessage voiceMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
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
          child: _VoiceBubbleMessagePlayer(
            voiceMessageLocation: voiceMessage.location,
          ),
        ),
      ],
    );
  }
}

class _VoiceBubbleMessagePlayer extends StatefulWidget {
  const _VoiceBubbleMessagePlayer({required this.voiceMessageLocation});

  final String voiceMessageLocation;

  @override
  State<_VoiceBubbleMessagePlayer> createState() =>
      _VoiceBubbleMessagePlayerState();
}

class _VoiceBubbleMessagePlayerState extends State<_VoiceBubbleMessagePlayer> {
  final PlayerController playerController = PlayerController();

  late Future<void> _preparePlayerFuture;

  final audioPlayerSlideStyle = PlayerWaveStyle(
    fixedWaveColor: Colors.grey, // Color del audio que falta por oír
    liveWaveColor: Colors.white, // Color del audio ya reproducido
    spacing: 5, // Espacio entre barras
    waveThickness: 3, // Grosor de cada barra
  );

  @override
  void initState() {
    super.initState();

    // 2. Inicializamos el Future solo una vez aquí
    _preparePlayerFuture = _preparePlayer();
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  Future<void> _preparePlayer() async {
    await playerController.preparePlayer(
      path: widget.voiceMessageLocation,
      shouldExtractWaveform: false,

      // Usamos un valor fijo o calculado una vez
      noOfSamples: audioPlayerSlideStyle.getSamplesForWidth(150),
    );

    await playerController.setFinishMode(finishMode: FinishMode.pause);

    // Escuchar cambios de estado para actualizar el icono de play/pause
    playerController.onPlayerStateChanged.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      // 3. Usamos la variable guardada, no la función directa
      future: _preparePlayerFuture,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState(colorScheme);
        }

        return Row(
          spacing: 8,
          children: [
            IconButton(
              onPressed: () async {
                if (playerController.playerState.isPlaying) {
                  await playerController.pausePlayer();
                } else {
                  playerController.startPlayer();
                }
                setState(() {});
              },
              icon: playerController.playerState.isPlaying
                  ? Icon(Icons.pause_rounded)
                  : Icon(Icons.play_arrow_rounded),
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
        );
      },
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Row(
      spacing: 8,
      children: [
        SizedBox.square(
          dimension: 40,
          child: Center(
            child: SizedBox.square(
              dimension: 25,
              child: CircularProgressIndicator(
                color: colorScheme.onPrimary,
                strokeWidth: 3,
                year2023: true,
              ),
            ),
          ),
        ),
        Expanded(
          child: LinearProgressIndicator(
            year2023: false,
            backgroundColor: colorScheme.surfaceContainerHighest,
            color: colorScheme.surface,
          ),
        ),
      ],
    );
  }
}
