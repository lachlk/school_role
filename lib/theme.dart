import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:school_role/main.dart';// Imports the required packages and files
import 'package:material_color_utilities/material_color_utilities.dart';

const _brandColor = Colors.blue; // The primary color

class DynamicTheme extends StatelessWidget {
  const DynamicTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CorePalette?>(
      future: DynamicColorPlugin.getCorePalette(),
      builder: (context, snapshot) {
        return DynamicColorBuilder(// Uses DynamicColorBuilder to dynamically change colors
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            ColorScheme lightColorTheme;
            ColorScheme darkColorTheme;

            if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
              final corePalette = snapshot.data!;
              lightColorTheme = ColorScheme.fromSeed(
                seedColor: Color(corePalette.primary.get(40)),
                outline: Colors.black,
              ).copyWith(secondary: Color(corePalette.secondary.get(40)));

              darkColorTheme = ColorScheme.fromSeed(
                seedColor: Color(corePalette.primary.get(40)),
                outline: Colors.white,
                brightness: Brightness.dark,
              ).copyWith(secondary: Color(corePalette.secondary.get(40)));
            }else {
              lightColorTheme = ColorScheme.fromSeed(
                  seedColor: _brandColor, outline: Colors.black);
              darkColorTheme = ColorScheme.fromSeed(
                seedColor: _brandColor,
                outline: Colors.white,
                brightness: Brightness.dark,
              );
            }

            return MaterialApp(
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightColorTheme, // Applying light color theme
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
    );
  }
}
