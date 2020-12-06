import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerObjeto {
  AudioPlayer _advancedPlayer;
  AudioCache _audioCache;
  String _localFilePath;
  double _sliderVal;
  Duration _duration;
  Duration _position;
  String _tempoMusica = "";
  bool _play = false;
  String _musicaAtual;

  AudioPlayerObjeto(
      this._advancedPlayer,
      this._audioCache,
      this._localFilePath,
      this._sliderVal,
      this._duration,
      this._position,
      this._tempoMusica,
      this._play,
      this._musicaAtual);

  String get musicaAtual => _musicaAtual;

  set musicaAtual(String value) {
    _musicaAtual = value;
  }

  bool get play => _play;

  set play(bool value) {
    _play = value;
  }

  String get tempoMusica => _tempoMusica;

  set tempoMusica(String value) {
    _tempoMusica = value;
  }

  Duration get position => _position;

  set position(Duration value) {
    _position = value;
  }

  Duration get duration => _duration;

  set duration(Duration value) {
    _duration = value;
  }

  double get sliderVal => _sliderVal;

  set sliderVal(double value) {
    _sliderVal = value;
  }

  String get localFilePath => _localFilePath;

  set localFilePath(String value) {
    _localFilePath = value;
  }

  AudioPlayer get advancedPlayer => _advancedPlayer;

  set advancedPlayer(AudioPlayer value) {
    _advancedPlayer = value;
  }

  AudioCache get audioCache => _audioCache;

  set audioCache(AudioCache value) {
    _audioCache = value;
  }
}
