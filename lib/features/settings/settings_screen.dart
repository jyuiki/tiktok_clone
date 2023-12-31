import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/video_configuration/video_config.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: width > Breakpoints.md ? Breakpoints.md : Breakpoints.sm,
          ),
          child: ListView(
            children: [
              ValueListenableBuilder(
                valueListenable: darkModeConfig,
                builder: (context, value, child) => SwitchListTile.adaptive(
                  value: value,
                  onChanged: (value) {
                    darkModeConfig.value = !darkModeConfig.value;
                  },
                  title: const Text("Enable Dark Mode"),
                  subtitle: Text(
                      "Current mode is ${darkModeConfig.value ? "Dark Mode" : "Light Mode"}"),
                ),
              ),
              SwitchListTile.adaptive(
                value: ref.watch(playbackConfigProvider).muted,
                onChanged: (value) =>
                    ref.read(playbackConfigProvider.notifier).setMuted(value),
                title: const Text("Muted Video"),
                subtitle: const Text("Video will be muted by default."),
              ),
              SwitchListTile.adaptive(
                value: ref.watch(playbackConfigProvider).autoPlay,
                onChanged: (value) => ref
                    .read(playbackConfigProvider.notifier)
                    .setAutoPlay(value),
                title: const Text("Autoplay"),
                subtitle: const Text("Video will start playing automatically."),
              ),
              Switch.adaptive(
                value: false,
                onChanged: (value) {},
              ),
              CupertinoSwitch(
                value: false,
                onChanged: (value) {},
              ),
              SwitchListTile.adaptive(
                value: false,
                onChanged: (value) {},
                title: const Text("Enable notification"),
                subtitle: const Text("Enable notification"),
              ),
              SwitchListTile(
                value: false,
                onChanged: (value) {},
                title: const Text("Enable notification"),
              ),
              Checkbox(
                value: false,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                value: false,
                onChanged: (value) {},
                title: const Text("Enable notification"),
                activeColor: Colors.black,
              ),
              ListTile(
                onTap: () async {
                  // final date = await showDatePicker(
                  //   context: context,
                  //   initialDate: DateTime.now(),
                  //   firstDate: DateTime(1980),
                  //   lastDate: DateTime(2030),
                  // );

                  // if (!mounted) return;
                  // final time = await showTimePicker(
                  //   context: context,
                  //   initialTime: TimeOfDay.now(),
                  // );

                  // if (!mounted) return;
                  // final booking = await showDateRangePicker(
                  //   context: context,
                  //   firstDate: DateTime(1980),
                  //   lastDate: DateTime(2030),
                  //   builder: (context, child) {
                  //     return Theme(
                  //       data: ThemeData(
                  //         appBarTheme: const AppBarTheme(
                  //           foregroundColor: Colors.white,
                  //           backgroundColor: Colors.black,
                  //         ),
                  //       ),
                  //       child: child!,
                  //     );
                  //   },
                  // );
                },
                title: const Text("What is your birthday?"),
              ),
              const AboutListTile(),
              ListTile(
                title: const Text(
                  "Logout (IOS)",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text(
                        "Are you sure?",
                      ),
                      content: const Text(
                        "Plx dont go",
                      ),
                      actions: [
                        CupertinoDialogAction(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            "No",
                          ),
                        ),
                        CupertinoDialogAction(
                          onPressed: () {
                            ref.read(authRepo).signOut();
                            context.go("/");
                          },
                          isDestructiveAction: true,
                          child: const Text(
                            "Yes",
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  "Logout (Android)",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      icon: const FaIcon(
                        FontAwesomeIcons.skull,
                      ),
                      title: const Text(
                        "Are you sure?",
                      ),
                      content: const Text(
                        "Plx dont go",
                      ),
                      actions: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const FaIcon(FontAwesomeIcons.car),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            "Yes",
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  "Logout (iOS/Bottom)",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      title: const Text(
                        "Are you sure?",
                      ),
                      message: const Text("Please dont go"),
                      actions: [
                        CupertinoActionSheetAction(
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Not log out"),
                        ),
                        CupertinoActionSheetAction(
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Yes plz"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
