import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/main.dart';
import 'package:tiktok_clone/utils.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  late final TabController _tabController;

  void _onSearchChanged(String value) {
    logger.d(value);
  }

  void _onSearchSubmitted(String value) {
    logger.d(value);
  }

  void _tabListener() {
    logger.i("tab changed index = ${tabs[_tabController.index]}");
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
    )..addListener(_tabListener);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _tabController.removeListener(_tabListener);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 1,
        title: SizedBox(
          height: Sizes.size44,
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.sm,
            ),
            child: TextField(
              controller: _textEditingController,
              onChanged: _onSearchChanged,
              onSubmitted: _onSearchSubmitted,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.size4),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDarkMode(context)
                    ? Colors.grey.shade700
                    : Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size20,
                ),
                prefixIcon: Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  opticalSize: 3,
                  color: isDarkMode(context) ? Colors.white : Colors.black,
                  size: Sizes.size20,
                ),
                suffixIcon: GestureDetector(
                  onTap: () => _textEditingController.clear(),
                  child: Icon(
                    FontAwesomeIcons.solidCircleXmark,
                    color: isDarkMode(context)
                        ? Colors.white
                        : Colors.grey.shade600,
                    size: Sizes.size16 + Sizes.size2,
                  ),
                ),
              ),
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          splashFactory: NoSplash.splashFactory,
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size16),
          isScrollable: true,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: Sizes.size16,
          ),
          tabs: [
            for (var tab in tabs)
              Tab(
                text: tab,
              ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const DiscoverGridview(),
          for (var tab in tabs.skip(1))
            Center(
              child: Text(
                tab,
                style: const TextStyle(fontSize: 28),
              ),
            )
        ],
      ),
    );
  }
}

class DiscoverGridview extends StatefulWidget {
  const DiscoverGridview({
    super.key,
  });

  @override
  State<DiscoverGridview> createState() => _DiscoverGridviewState();
}

///
/// TabBarView가 tab이 이동 할때 마다 새로 그리는걸 방지.
/// 1. with AutomaticKeepAliveClientMixin
/// 2. build 메서드에  super.build(context) 추가
/// 3. bool get wantKeepAlive => true; 추가
class _DiscoverGridviewState extends State<DiscoverGridview>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final width = MediaQuery.of(context).size.width;
    logger.i(width);
    return GridView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: 20,
      padding: const EdgeInsets.all(Sizes.size6),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width > Breakpoints.lg ? 5 : 2,
        crossAxisSpacing: Sizes.size10,
        mainAxisSpacing: Sizes.size10,
        childAspectRatio: 9 / 20,
      ),
      itemBuilder: (context, index) => LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.size4),
              ),
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    placeholder: "assets/images/dayeon.jpeg",
                    image:
                        "https://images.unsplash.com/photo-1673844969019-c99b0c933e90?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1480&q=80"),
              ),
            ),
            Gaps.v10,
            const Text(
              "This is Very long caption for my tiktok blabalalbalablalblablabalalbalablalblablabalalbalablalbla",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: Sizes.size16 + Sizes.size2,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gaps.v5,
            // if (constraints.maxWidth < 200 || constraints.maxWidth > 250)
            DefaultTextStyle(
              style: TextStyle(
                color: isDarkMode(context)
                    ? Colors.grey.shade300
                    : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(
                        "https://github.githubassets.com/images/modules/profile/achievements/pull-shark-default.png"),
                  ),
                  Gaps.h8,
                  const Expanded(
                    child: Text(
                      "https://github.githubassets.com/images/modules/profile/achi",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Gaps.h8,
                  FaIcon(
                    FontAwesomeIcons.heart,
                    size: Sizes.size16,
                    color: Colors.grey.shade600,
                  ),
                  Gaps.h2,
                  const Text(
                    "2.5M",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
