import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:material_splash_screen/AudioPlayerObjeto.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class AudioPlayerController extends BlocBase {
  BehaviorSubject<AudioPlayerObjeto> durB =
      new BehaviorSubject<AudioPlayerObjeto>();
  Stream<AudioPlayerObjeto> get outPlayer => durB.stream;
  Sink<AudioPlayerObjeto> get inPlayer => durB.sink;

  AudioPlayer advancedPlayer = new AudioPlayer();
  AudioPlayerObjeto audioObjeto;

  AudioPlayerController() {
    audioObjeto = new AudioPlayerObjeto(
        advancedPlayer,
        new AudioCache(fixedPlayer: advancedPlayer),
        "",
        0,
        new Duration(),
        new Duration(),
        "",
        false,
        "");

    audioObjeto.advancedPlayer.onDurationChanged.listen((Duration d) {
      audioObjeto.duration = d;
      inPlayer.add(audioObjeto);
    });

    audioObjeto.advancedPlayer.onAudioPositionChanged.listen((Duration p) {
      audioObjeto.position = p;
      inPlayer.add(audioObjeto);
    });

    audioObjeto.musicaAtual = "ifood_audio.mp3";
    inPlayer.add(audioObjeto);
  }

  botaoPlayPause() {
    if (audioObjeto.play) {
      audioObjeto.play = false;
      audioObjeto.advancedPlayer.pause();
    } else {
      audioObjeto.play = true;
      audioObjeto.audioCache.play(audioObjeto.musicaAtual);
    }
    inPlayer.add(audioObjeto);
  }

  tempoMusica(double newValue) {
    Duration newDuration = Duration(seconds: newValue.toInt());

    audioObjeto.advancedPlayer.seek(newDuration);

    audioObjeto.tempoMusica = newValue.toStringAsFixed(0);
    audioObjeto.advancedPlayer.resume();
    audioObjeto.play = true;
    inPlayer.add(audioObjeto);
    print(newValue.toInt());
  }

  @override
  void dispose() {}
}

AudioPlayerController audioC = new AudioPlayerController();
