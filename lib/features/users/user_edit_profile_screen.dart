import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/main.dart';

class UserEditProfileScreen extends ConsumerStatefulWidget {
  static const String routeName = "editProfile";
  static const String routeURL = "/editProfile";

  const UserEditProfileScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserEditProfileScreenState();
}

class _UserEditProfileScreenState extends ConsumerState<UserEditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  Future<void> _onSubmitEditValue() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        var introduction = "undefined";
        var link = "undefined";

        if (_formData["introduction"]?.isNotEmpty ?? false) {
          introduction = _formData["introduction"]!;
        }

        if (_formData["link"]?.isNotEmpty ?? false) {
          link = _formData["link"]!;
        }

        logger.d("introduction = $introduction");
        logger.d("link = $link");

        bool isSubmit =
            await ref.read(userProvider.notifier).onEditUserProfile({
          "introduction": introduction,
          "link": link,
        });

        if (mounted && isSubmit) {
          Navigator.pop(context);
        }
      }
    }
  }

  String getInitialString(String value) {
    return value == "undefined" ? "" : value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v28,
              const Text("Introduction"),
              TextFormField(
                initialValue: getInitialString(
                    ref.read(userProvider).value?.introduction ?? "undefined"),
                decoration: InputDecoration(
                  hintText: getInitialString(
                              ref.read(userProvider).value?.introduction ??
                                  "undefined")
                          .isEmpty
                      ? "undefined"
                      : null,
                ),
                validator: (value) {
                  return null;
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    _formData["introduction"] = newValue;
                  }
                },
              ),
              Gaps.v28,
              const Text("link"),
              TextFormField(
                initialValue: getInitialString(
                    ref.read(userProvider).value?.link ?? "undefined"),
                decoration: InputDecoration(
                  hintText: getInitialString(
                              ref.read(userProvider).value?.link ?? "undefined")
                          .isEmpty
                      ? "undefined"
                      : null,
                ),
                validator: (value) {
                  return null;
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    _formData["link"] = newValue;
                  }
                },
              ),
              Gaps.v28,
              GestureDetector(
                onTap: _onSubmitEditValue,
                child: const FormButton(
                  disabled: false,
                  text: "Submit",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
