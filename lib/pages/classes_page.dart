import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:school_role/main.dart'; // Imports required packages and pages

class ClassesList extends StatelessWidget {
  const ClassesList({super.key}); // Widget for the ClassesList body

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
    ]; // List of classrooms

    return Scrollbar(
      // Widget for scrollbar
      thickness: 10,
      radius: const Radius.circular(5),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).size.shortestSide < 600 ? 2 : 4),
        itemCount: classes.length,
        itemBuilder: (BuildContext context, classroom) {
          return Card(
            // Card for the packground of each class
            margin: const EdgeInsets.all(10),
            elevation: 1,
            surfaceTintColor: Theme.of(context).colorScheme.primary.harmonizeWith(Colors.white),
            child: GestureDetector(
              // Detects clicking of the card
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ThirdRoute(),
                  ),
                );
              },
              child: Column(
                children: [
                  Expanded(
                      child: FittedBox(
                    fit: BoxFit.fill,
                    child: Icon(Icons.groups,
                        color: Theme.of(context).colorScheme.outline),
                  )),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(classes[classroom])),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
