import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  @override
  FutureOr<UserProfileModel> build() {
    return UserProfileModel.empty();
  }

  Future<void> createAccount(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not create");
    }
    state = AsyncValue.data(
      UserProfileModel(
        uid: credential.user!.uid,
        email: credential.user!.email ?? "anon@anon.com",
        name: credential.user!.displayName ?? "Anon",
        bio: "undefined",
        link: "undefined",
      ),
    );
  }
}

final userProvider = AsyncNotifierProvider(
  () => UsersViewModel(),
);
