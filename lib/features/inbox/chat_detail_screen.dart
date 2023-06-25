import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _editingController = TextEditingController();

  bool _isTextEditing = false;
  Color _sendIconBackgroundColor = Colors.grey.shade300;

  @override
  void initState() {
    super.initState();

    _editingController.addListener(_onStartEditing);
  }

  @override
  void dispose() {
    _editingController.removeListener(_onStartEditing);
    _editingController.dispose();
    super.dispose();
  }

  void _onStartEditing() {
    if (!_isTextEditing && _editingController.text.isNotEmpty) {
      setState(() {
        _isTextEditing = true;
        _sendIconBackgroundColor = Theme.of(context).primaryColor;
      });
    } else if (_isTextEditing && _editingController.text.isEmpty) {
      setState(() {
        _isTextEditing = false;
        _sendIconBackgroundColor = Colors.grey.shade300;
      });
    }
  }

  void _onCloseKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: Stack(
            children: [
              const CircleAvatar(
                radius: Sizes.size24,
                foregroundImage: NetworkImage(
                    "https://github.githubassets.com/images/modules/profile/achievements/pull-shark-default.png"),
                child: Text("xxxxmmm967"),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: Sizes.size20,
                  height: Sizes.size20,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: Sizes.size3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          title: const Text(
            "xxxxmmm967",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: const Text("Active now"),
          trailing: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.flag,
                color: Colors.black,
                size: Sizes.size20,
              ),
              Gaps.h32,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                color: Colors.black,
                size: Sizes.size20,
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: _onCloseKeyboard,
        child: Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.only(
                top: Sizes.size20,
                left: Sizes.size14,
                right: Sizes.size14,
                bottom: Sizes.size96 + Sizes.size20,
              ),
              itemBuilder: (context, index) {
                final isMine = index % 2 == 0;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                      isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _onCloseKeyboard();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(
                          Sizes.size14,
                        ),
                        decoration: BoxDecoration(
                          color: isMine
                              ? Colors.blue
                              : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(Sizes.size20),
                            topRight: const Radius.circular(Sizes.size20),
                            bottomLeft: Radius.circular(
                                isMine ? Sizes.size20 : Sizes.size5),
                            bottomRight: Radius.circular(
                                isMine ? Sizes.size5 : Sizes.size20),
                          ),
                        ),
                        child: const Text(
                          "This is a message!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Sizes.size16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => Gaps.v10,
              itemCount: 20,
            ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: BottomAppBar(
                elevation: 0,
                color: const Color(0xFFF4F4F4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size14,
                    vertical: Sizes.size10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: TextField(
                            controller: _editingController,
                            expands: true,
                            minLines: null,
                            maxLines: null,
                            textInputAction: TextInputAction.newline,
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                                hintText: "Send a message...",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(Sizes.size18),
                                    topRight: Radius.circular(Sizes.size18),
                                    bottomLeft: Radius.circular(Sizes.size18),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.size20,
                                ),
                                suffixIcon: const Icon(
                                  FontAwesomeIcons.faceSmile,
                                  size: 24,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ),
                      Gaps.h20,
                      AnimatedContainer(
                        width: 35,
                        height: 35,
                        duration: const Duration(milliseconds: 500),
                        decoration: BoxDecoration(
                          color: _sendIconBackgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.paperPlane,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
