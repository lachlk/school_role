import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:school_role/main.dart';// Imports the required packages and files

const _brandColor = Colors.blue; // The primary color

class DynamicTheme extends StatelessWidget {
  const DynamicTheme({super.key});

  Future<Color> getSeedColor() async {
    final corePalette = await DynamicColorPlugin.getCorePalette();
    if (corePalette != null) {
      return Color(corePalette.primary.get(40));
    }

    final accentColor = await DynamicColorPlugin.getAccentColor();
    if (accentColor != null) {
      return accentColor;
    }

    return _brandColor;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Color>(
      future: getSeedColor(),
      builder: (context, snapshot) {
        final Color seedColor = (snapshot.connectionState == ConnectionState.done && snapshot.hasData)
            ? snapshot.data!
            : _brandColor;

        return MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: seedColor), // Applying light color theme
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.dark), // Applying dark color theme
          ),
          debugShowCheckedModeBanner: false, // Hides debug banner
          home: const FirstRoute(),
        );
      },
    );
  }
}