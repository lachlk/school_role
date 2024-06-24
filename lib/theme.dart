import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:school_role/main.dart';// Imports the required packages and files

const _brandColor = Colors.grey; // The primary color

class DynamicTheme extends StatelessWidget {
  const DynamicTheme(
      {super.key, required FirstRoute home});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      // Uses DynamicColorBuilder to dynamically change colors
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorTheme;
        ColorScheme darkColorTheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightColorTheme =
              lightDynamic.harmonized(); // Harmonizes light color theme
          lightColorTheme = lightColorTheme.copyWith(
              outline: Colors.black,
              secondary: _brandColor); // Customizing light color theme

          darkColorTheme =
              darkDynamic.harmonized(); // Harmonizes dark color theme
          darkColorTheme = darkColorTheme.copyWith(
              outline: Colors.grey,
              secondary: _brandColor); // Customizing dark color theme
        } else {
          lightColorTheme = ColorScheme.fromSeed(
              seedColor: _brandColor, outline: Colors.black);
          darkColorTheme = ColorScheme.fromSeed(
            seedColor: _brandColor,
            outline: Colors.grey,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          theme: ThemeData(
            colorScheme: lightColorTheme, // Applying light color theme
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorTheme, // Applying dark color theme
          ),
          debugShowCheckedModeBanner: false, // Hides debug banner
          home: const FirstRoute(),
        );
      },
    );
  }
}
