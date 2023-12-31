import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repos/user_repository.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _usersRepository;
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    _usersRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);

    if (_authenticationRepository.isLoggedIn) {
      final profile = await _usersRepository
          .findProfile(_authenticationRepository.user!.uid);

      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }
    return UserProfileModel.empty();
  }

  Future<void> createProfile(
      UserCredential credential, Map<dynamic, dynamic> form) async {
    if (credential.user == null) {
      throw Exception("Account not create");
    }

    state = const AsyncValue.loading();

    final profile = UserProfileModel(
      hasAvatar: false,
      uid: credential.user!.uid,
      email: credential.user!.email ?? "anon@anon.com",
      name: form["username"] ?? "Anon",
      bio: form["bio"] ?? "undefined",
      link: "undefined",
      introduction: "undefined",
    );

    await _usersRepository.createProfile(profile);
    state = AsyncValue.data(profile);
  }

  Future<void> onAvatarUpload() async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));
    await _usersRepository.updateUser(state.value!.uid, {"hasAvatar": true});
  }

  Future<bool> onEditUserProfile(Map<String, String> profileMap) async {
    if (state.value == null) return false;

    state = AsyncValue.data(
      state.value!.copyWith(
        introduction: profileMap["introduction"] ?? "undefined",
        link: profileMap["link"] ?? "undefined",
      ),
    );

    await _usersRepository.updateUser(state.value!.uid, profileMap);

    return true;
  }
}

final userProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
