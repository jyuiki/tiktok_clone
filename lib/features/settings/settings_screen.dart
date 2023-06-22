import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: const Column(
        children: [
          CircularProgressIndicator.adaptive(),
        ],
      ),

      // CloseButton(),

      // ListWheelScrollView(
      //   diameterRatio: 1.5,
      //   offAxisFraction: 2,
      //   itemExtent: 200,
      //   children: [
      //     for (var x in [1, 2, 2, 2, 2, 2, 34, 3, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3])
      //       FractionallySizedBox(
      //         widthFactor: 1,
      //         child: Container(
      //           color: Colors.teal,
      //           alignment: Alignment.center,
      //           child: const Text(
      //             "data",
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontSize: 39,
      //             ),
      //           ),
      //         ),
      //       )
      //   ],
      // ),
    );
  }
}
