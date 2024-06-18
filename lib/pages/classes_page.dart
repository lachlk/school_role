import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

class ClassesList extends StatelessWidget {
  const ClassesList({super.key});

  @override
  Widget build(BuildContext context) {
    var classes = [
      '7BIO',
      '7DIT',
      '7PHX',
      '7CHE',
      '7ENG',
      '7MAC',
    ];

    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          for (var classroom in classes)
          Card.filled(
            margin: const EdgeInsets.all(10),
            elevation: 4,
            surfaceTintColor: Theme.of(context).colorScheme.primary.harmonizeWith(Colors.white),
            child: Text(classroom),
          )],
      ),
    );
  }
}