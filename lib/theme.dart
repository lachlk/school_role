import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:school_role/main.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DynamicTheme(
      home: Header(),
    );
  }
}

const _brandColor = Colors.green;

class DynamicTheme extends StatelessWidget {
  const DynamicTheme({super.key, required Header home});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorTheme;
        ColorScheme darkColorTheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightColorTheme = lightDynamic.harmonized();
          lightColorTheme = lightColorTheme.copyWith(secondary: _brandColor);

          darkColorTheme = darkDynamic.harmonized();
          darkColorTheme = darkColorTheme.copyWith(secondary: _brandColor);
        } else {
          lightColorTheme = ColorScheme.fromSeed(
            seedColor: _brandColor,
            brightness: Brightness.light,
          );
          darkColorTheme = ColorScheme.fromSeed(
            seedColor: _brandColor,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          theme: ThemeData(
            colorScheme: lightColorTheme,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorTheme,
          ),
          debugShowCheckedModeBanner: false,
          home: const Header(),
        );
      },
    );
  }
}
