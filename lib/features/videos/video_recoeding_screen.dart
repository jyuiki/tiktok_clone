import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/video_preview_screen.dart';
import 'package:tiktok_clone/main.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  static const String routeName = "postVideo";
  static const String routeURL = "/upload";

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;

  bool _isSelfieMode = false;

  late final bool _noCamera = kDebugMode && Platform.isIOS;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> _buttonAnimation =
      Tween(begin: 1.0, end: 1.3).animate(_buttonAnimationController);

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  late FlashMode _flashMode;

  late CameraController _cameraController;

  late final double _dragStartPosition =
      (MediaQuery.of(context).size.height - Sizes.size80).floorToDouble();

  late final double _verticalDragMaxHeight =
      _dragStartPosition - kToolbarHeight - 150;

  late final double _cameraMaxZoomLevel;

  double _zoomLevel = 1.0;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_hasPermission) return;
    if (!_cameraController.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      _isSelfieMode ? cameras.last : cameras.first,
      ResolutionPreset.ultraHigh,
    );

    await _cameraController.initialize();

    await _cameraController.prepareForVideoRecording();

    _cameraMaxZoomLevel = await _cameraController.getMaxZoomLevel();
    logger.d("maxZoomLevel = $_cameraMaxZoomLevel");

    _flashMode = _cameraController.value.flashMode;

    setState(() {});
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;
    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    } else {
      if (!mounted) return;

      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text(
            "Permission warning!!",
          ),
          content: const Text(
            "Please allow permissions in your settings!!",
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
                Navigator.of(context).pop();
                openAppSettings();
              },
              isDestructiveAction: true,
              child: const Text(
                "Yes",
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (!_noCamera) {
      initPermissions();

      WidgetsBinding.instance.addObserver(this);
      _progressAnimationController.addListener(() {
        setState(() {});
      });
      _progressAnimationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _stopRecording();
        }
      });
    } else {
      setState(() {
        _hasPermission = true;
      });
    }
  }

  @override
  void dispose() {
    if (!_noCamera) {
      _buttonAnimationController.dispose();
      _cameraController.dispose();
      _progressAnimationController.dispose();
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  Future<void> _startRecording(TapDownDetails _) async {
    if (_noCamera || _cameraController.value.isRecordingVideo) return;

    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (_noCamera || !_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final video = await _cameraController.stopVideoRecording();

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: false,
        ),
      ),
    );
  }

  Future<void> _onPickVideoPressed() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (video == null) return;

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: true,
        ),
      ),
    );
  }

  Future<void> _onUpdateCameraZoom(DragUpdateDetails details) async {
    if (_noCamera) return;
    double dragY =
        _dragStartPosition - details.globalPosition.dy.floorToDouble();
    double zoomLevel = 1.0;

    zoomLevel += (dragY * _cameraMaxZoomLevel) / _verticalDragMaxHeight;

    if (zoomLevel > _cameraMaxZoomLevel) {
      zoomLevel = _cameraMaxZoomLevel;
    } else if (dragY <= 0) {
      zoomLevel = 1.0;
    }

    if (dragY <= _verticalDragMaxHeight) {
      logger.d("zoomLevel = $zoomLevel");
      await _cameraController.setZoomLevel(zoomLevel);
      setState(() {
        _zoomLevel = zoomLevel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: !_hasPermission
              ? const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Initailizing...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size20,
                      ),
                    ),
                    Gaps.v20,
                    CircularProgressIndicator.adaptive(),
                  ],
                )
              : Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (!_noCamera && _cameraController.value.isInitialized)
                        CameraPreview(_cameraController),
                      const Positioned(
                        top: Sizes.size20,
                        left: Sizes.size20,
                        child: CloseButton(
                          color: Colors.white,
                        ),
                      ),
                      if (!_noCamera)
                        Positioned(
                          top: Sizes.size20,
                          right: Sizes.size20,
                          child: Column(
                            children: [
                              IconButton(
                                color: Colors.white,
                                onPressed: _toggleSelfieMode,
                                icon: const Icon(
                                  Icons.cameraswitch,
                                ),
                              ),
                              Gaps.v10,
                              FlashButton(
                                icon: Icons.flash_off_rounded,
                                isSelected: _flashMode == FlashMode.off,
                                onPressed: () => _setFlashMode(FlashMode.off),
                              ),
                              Gaps.v10,
                              FlashButton(
                                icon: Icons.flash_on_rounded,
                                isSelected: _flashMode == FlashMode.always,
                                onPressed: () =>
                                    _setFlashMode(FlashMode.always),
                              ),
                              Gaps.v10,
                              FlashButton(
                                icon: Icons.flash_auto_rounded,
                                isSelected: _flashMode == FlashMode.auto,
                                onPressed: () => _setFlashMode(FlashMode.auto),
                              ),
                              Gaps.v10,
                              FlashButton(
                                icon: Icons.flashlight_on_rounded,
                                isSelected: _flashMode == FlashMode.torch,
                                onPressed: () => _setFlashMode(FlashMode.torch),
                              ),
                            ],
                          ),
                        ),
                      Positioned(
                        bottom: Sizes.size40,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            const Spacer(),
                            GestureDetector(
                              dragStartBehavior: DragStartBehavior.start,
                              onVerticalDragUpdate:
                                  _noCamera || _cameraMaxZoomLevel <= 1.0
                                      ? null
                                      : _onUpdateCameraZoom,
                              onTapDown: _startRecording,
                              onTapUp: (_) => _stopRecording(),
                              child: ScaleTransition(
                                scale: _buttonAnimation,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: Sizes.size80 + Sizes.size14,
                                      height: Sizes.size80 + Sizes.size14,
                                      child: CircularProgressIndicator(
                                        color: Colors.red.shade400,
                                        strokeWidth: Sizes.size6,
                                        value:
                                            _progressAnimationController.value,
                                      ),
                                    ),
                                    Container(
                                      width: Sizes.size80,
                                      height: Sizes.size80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: _onPickVideoPressed,
                                  icon: const FaIcon(
                                    FontAwesomeIcons.image,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 20,
                        top: 20,
                        child: Text(
                          "X ${_zoomLevel.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: Sizes.size24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class FlashButton extends StatelessWidget {
  final bool isSelected;
  final IconData icon;
  final VoidCallback onPressed;

  const FlashButton({
    super.key,
    required this.isSelected,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: isSelected ? Colors.amber.shade200 : Colors.white,
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
