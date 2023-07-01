import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class Avartar extends ConsumerWidget {
  final String name;

  const Avartar({
    super.key,
    required this.name,
  });

  Future<void> _onAvartarTap() async {
    ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: _onAvartarTap,
      child: CircleAvatar(
        radius: 50,
        foregroundColor: Colors.blue,
        foregroundImage: const NetworkImage(
            "https://github.githubassets.com/images/modules/profile/achievements/pull-shark-default.png"),
        child: Text(name),
      ),
    );
  }
}
