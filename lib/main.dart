import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 3, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
      ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle.dark,
  // );

  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TikTok Clone',
      themeMode: ThemeMode.system,
      theme: ThemeData(
          useMaterial3: true,
          textTheme: Typography.blackMountainView,
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: const Color(0xFFE9435A),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFE9435A),
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: Sizes.size16 + Sizes.size2,
              fontWeight: FontWeight.w600,
            ),
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.grey.shade500,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          listTileTheme: const ListTileThemeData(
            iconColor: Colors.black,
          )),
      darkTheme: ThemeData(
        useMaterial3: true,
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade700,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE9435A),
        ),
        textTheme: Typography.whiteMountainView,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey.shade900,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
          surfaceTintColor: Colors.grey.shade900,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.grey.shade100,
          ),
          iconTheme: IconThemeData(
            color: Colors.grey.shade100,
          ),
        ),
        primaryColor: const Color(0xFFE9435A),
      ),
      home: const SignUpScreen(),
    );
  }
}
