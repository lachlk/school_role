import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:school_role/main.dart';

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
      '6MAC',
      '6CHE'
    ];

    return Scaffold(
      body: GridView.count(
        crossAxisCount: MediaQuery.of(context).size.shortestSide < 600  ? 2:4,
        children: <Widget>[
          for (var classroom in classes)
            Card.filled(
              margin: const EdgeInsets.all(10),
              elevation: 1,
              surfaceTintColor: Theme.of(context)
                  .colorScheme
                  .primary
                  .harmonizeWith(Colors.white),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const SecondRoute())
                  );
                },
                child: Column(
                  children: [
                    Expanded(
                      child: FittedBox(
                      fit: BoxFit.fill,
                      child: Icon(Icons.groups, color: Theme.of(context).colorScheme.outline),
                    )),
                    Center(child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(classroom)),
                    ),
                  ],
                ))
            )
        ],
      ),
    );
  }
}
