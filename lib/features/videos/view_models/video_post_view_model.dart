import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class VideoPostViewModel extends FamilyAsyncNotifier<bool, String> {
  late final VideosRepository _repository;
  late final String _videoId;
  late bool _isLiked;

  @override
  FutureOr<bool> build(String arg) async {
    _videoId = arg;
    _repository = ref.read(videosRepo);

    final uid = ref.read(authRepo).user!.uid;
    var likes = await _repository.getLikesVideosByUserId(uid, _videoId);
    _isLiked = likes?.containsValue(_videoId) ?? false;
    return _isLiked;
  }

  Future<void> toggleLikeVideo() async {
    final user = ref.read(authRepo).user;

    state = await AsyncValue.guard(() async {
      await _repository.likeVideo(_videoId, user!.uid);
      _isLiked = !_isLiked;
      return _isLiked;
    });
  }
}

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostViewModel, bool, String>(
  () => VideoPostViewModel(),
);
