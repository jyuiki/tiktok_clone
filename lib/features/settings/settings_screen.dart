import 'package:flutter/material.dart';
import 'package:tiktok_clone/main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
              );
              logger.i(date);

              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              logger.i(time);

              final booking = await showDateRangePicker(
                context: context,
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData(
                      appBarTheme: const AppBarTheme(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              logger.i(booking);
            },
            title: const Text("What is your birthday?"),
          ),
          const AboutListTile(),
        ],
      ),
    );
  }
}
