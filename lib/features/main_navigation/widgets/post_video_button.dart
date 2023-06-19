import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class PostVideoButton extends StatefulWidget {
  const PostVideoButton({
    super.key,
    required Function onPostVideoButtonTap,
    required this.inverted,
  }) : _onPostVideoButtonTap = onPostVideoButtonTap;

  final Function _onPostVideoButtonTap;
  final bool inverted;

  @override
  State<PostVideoButton> createState() => _PostVideoButtonState();
}

class _PostVideoButtonState extends State<PostVideoButton> {
  final double _height = 30.0;
  final double _width = 25.0;
  final double _insetDistance = 20.0;
  final double _scale = 1.2;

  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget._onPostVideoButtonTap(),
      onTapDown: (details) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedSize(
        clipBehavior: Clip.none,
        duration: const Duration(milliseconds: 500),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: _isPressed ? _insetDistance * _scale : _insetDistance,
              child: Container(
                height: _isPressed ? _height * _scale : _height,
                width: _isPressed ? _width * _scale : _width,
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size8),
                decoration: BoxDecoration(
                  color: const Color(0xFF61D4F0),
                  borderRadius: BorderRadius.circular(Sizes.size8),
                ),
              ),
            ),
            Positioned(
              left: _isPressed ? _insetDistance * _scale : _insetDistance,
              child: Container(
                height: _isPressed ? _height * _scale : _height,
                width: _isPressed ? _width * _scale : _width,
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(Sizes.size8),
                ),
              ),
            ),
            Container(
              height: _isPressed ? _height * _scale : _height,
              padding: EdgeInsets.symmetric(
                  horizontal:
                      _isPressed ? Sizes.size12 * _scale : Sizes.size12),
              decoration: BoxDecoration(
                color: widget.inverted ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(Sizes.size6),
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.plus,
                  color: widget.inverted ? Colors.white : Colors.black,
                  size: _isPressed ? 18 * _scale : 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
