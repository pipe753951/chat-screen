import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';

class AudioPlayerSlider extends StatelessWidget {
  const AudioPlayerSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return const AudioPlayerClassicSlider();
  }
}

class AudioPlayerClassicSlider extends StatefulWidget {
  const AudioPlayerClassicSlider({super.key});

  @override
  State<AudioPlayerClassicSlider> createState() =>
      _AudioPlayerClassicSliderState();
}

class _AudioPlayerClassicSliderState extends State<AudioPlayerClassicSlider> {
  double value = 0;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Slider(
      value: value,
      onChanged: (double newValue) {
        setState(() {
          value = newValue;
        });
      },

      min: 0,
      max: 100,

      padding: EdgeInsets.only(right: 10),
      activeColor: colorScheme.onPrimary,
    );
  }
}

class AudioPlayerWaveSlider extends StatefulWidget {
  const AudioPlayerWaveSlider({super.key});

  @override
  State<AudioPlayerWaveSlider> createState() => _AudioPlayerWaveSliderState();
}

class _AudioPlayerWaveSliderState extends State<AudioPlayerWaveSlider> {
  final PlayerController playerController = PlayerController();
  bool _isAudioReady = false;

  Future<void> prepareAudio() async {
    // TODO: Remove testing audio loading
    final audioFile = await rootBundle.load('assets/test/music/2.mp3');
    final directory = await getApplicationCacheDirectory();
    final file = File('${directory.path}/audio.mp3');
    await file.writeAsBytes(audioFile.buffer.asUint8List());

    await playerController.preparePlayer(
      path: file.path,
      shouldExtractWaveform: true,
    );

    setState(() {
      _isAudioReady = true;
    });
  }

  @override
  void initState() {
    prepareAudio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAudioReady) {
      return Center(child: CircularProgressIndicator());
    }

    return AudioFileWaveforms(
      size: Size(150, 40),
      playerController: playerController,
      enableSeekGesture: true,
      waveformType: WaveformType.fitWidth,
      playerWaveStyle: const PlayerWaveStyle(
        fixedWaveColor: Colors.grey, // Color del audio que falta por oír
        liveWaveColor: Colors.blue, // Color del audio ya reproducido
        spacing: 5, // Espacio entre barras
        waveThickness: 3, // Grosor de cada barra
      ),
    );
  }
}
