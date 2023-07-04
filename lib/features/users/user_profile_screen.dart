import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/settings_screen.dart';
import 'package:tiktok_clone/features/users/user_edit_profile_screen.dart';
import 'package:tiktok_clone/features/users/widget/avatar.dart';
import 'package:tiktok_clone/features/users/widget/persistent_tab_bar.dart';

import 'view_models/users_view_model.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String username;
  final String tab;

  const UserProfileScreen({
    super.key,
    required this.username,
    required this.tab,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  void _onGearPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _onEditPressed() {
    // ref.read(userProvider.notifier).onEditUserProfile(
    //     {"introduction": DateTime.now().millisecond.toString()});

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserEditProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ref.watch(userProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => Scaffold(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            body: SafeArea(
              child: DefaultTabController(
                initialIndex: widget.tab == "likes" ? 1 : 0,
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        title: Text(data.name),
                        centerTitle: true,
                        actions: [
                          IconButton(
                            onPressed: _onEditPressed,
                            icon: const FaIcon(
                              FontAwesomeIcons.penToSquare,
                              size: Sizes.size20,
                            ),
                          ),
                          IconButton(
                            onPressed: _onGearPressed,
                            icon: const FaIcon(
                              FontAwesomeIcons.gear,
                              size: Sizes.size20,
                            ),
                          ),
                        ],
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Gaps.v20,
                            Avartar(
                              uid: data.uid,
                              name: data.name,
                              hasAvatar: data.hasAvatar,
                            ),
                            Gaps.v20,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "@${data.name}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Sizes.size18,
                                  ),
                                ),
                                Gaps.h5,
                                FaIcon(
                                  FontAwesomeIcons.solidCircleCheck,
                                  size: Sizes.size16,
                                  color: Colors.blue.shade500,
                                ),
                              ],
                            ),
                            Gaps.v24,
                            SizedBox(
                              height: Sizes.size52,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _getAccountInfoWidget(
                                    counts: "37",
                                    type: "Following",
                                  ),
                                  _getVerticalDivider(),
                                  _getAccountInfoWidget(
                                    counts: "10.5M",
                                    type: "Followers",
                                  ),
                                  _getVerticalDivider(),
                                  _getAccountInfoWidget(
                                    counts: "149.3M",
                                    type: "Likes",
                                  ),
                                ],
                              ),
                            ),
                            Gaps.v14,
                            SizedBox(
                              height: 45,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.size80,
                                ),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: Breakpoints.sm,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(
                                                Sizes.size4,
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            "Follow",
                                            style: TextStyle(
                                              fontSize: Sizes.size16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Gaps.h4,
                                      AspectRatio(
                                        aspectRatio: 1,
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(
                                                Sizes.size4,
                                              ),
                                            ),
                                          ),
                                          child: const FaIcon(
                                            FontAwesomeIcons.youtube,
                                            size: Sizes.size20,
                                          ),
                                        ),
                                      ),
                                      Gaps.h4,
                                      AspectRatio(
                                        aspectRatio: 1,
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(
                                                Sizes.size4,
                                              ),
                                            ),
                                          ),
                                          child: const FaIcon(
                                            FontAwesomeIcons.caretDown,
                                            size: Sizes.size16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Gaps.v14,
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.size32,
                              ),
                              child: Text(
                                // "All highlights and where to watch live matches on FIFA+",
                                data.introduction,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Gaps.v14,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.link,
                                  size: Sizes.size12,
                                ),
                                Gaps.h4,
                                Text(
                                  data.link,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Gaps.v20,
                          ],
                        ),
                      ),
                      SliverPersistentHeader(
                        delegate: PersistentTabBar(),
                        pinned: true,
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: 20,
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: width > Breakpoints.lg ? 5 : 3,
                          crossAxisSpacing: Sizes.size2,
                          mainAxisSpacing: Sizes.size2,
                          childAspectRatio: 9 / 14,
                        ),
                        itemBuilder: (context, index) => AspectRatio(
                          aspectRatio: 9 / 14,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: FadeInImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    placeholder: "assets/images/dayeon.jpeg",
                                    image:
                                        "https://images.unsplash.com/photo-1673844969019-c99b0c933e90?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1480&q=80"),
                              ),
                              Positioned(
                                left: 0,
                                bottom: 0,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.play_arrow_outlined,
                                      color: Colors.white,
                                      size: Sizes.size28,
                                    ),
                                    Text(
                                      _getViewerCountText(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Center(
                        child: Text("data"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
  }

  String _getViewerCountText() =>
      "${(Random().nextDouble() * 999.0).toStringAsFixed(1)}${Random().nextBool() ? "M" : "K"}";

  Column _getAccountInfoWidget({
    required String counts,
    required String type,
  }) {
    return Column(
      children: [
        Text(
          counts,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Sizes.size18,
          ),
        ),
        Gaps.v3,
        Text(
          type,
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  VerticalDivider _getVerticalDivider() {
    return VerticalDivider(
      width: Sizes.size32,
      thickness: Sizes.size1,
      color: Colors.grey.shade400,
      indent: Sizes.size14,
      endIndent: Sizes.size14,
    );
  }
}
