import 'package:flutter/widgets.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/playback_config_repo.dart';

class PlaybackConfigViewModel extends ChangeNotifier {
  final PlaybackConfigRepository _repository;
  late final PlaybackConfingModel _model = PlaybackConfingModel(
    muted: _repository.isMuted(),
    autoPlay: _repository.isAutoPlay(),
  );

  PlaybackConfigViewModel(this._repository);

  bool get muted => _model.muted;

  bool get autoPlay => _model.autoPlay;

  void setMuted(bool value) {
    _repository.setMuted(value);
    _model.muted = value;
    notifyListeners();
  }

  void setAutoPlay(bool value) {
    _repository.setAutoPlay(value);
    _model.autoPlay = value;
    notifyListeners();
  }
}
