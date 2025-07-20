import 'package:Eresse/discussions/data/QueryDataStructure.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

typedef QueryPressed = void Function(QueryDataStructure queryDataStructure);

class QueryElement extends StatelessWidget {

  /// Serial Data
  final QueryDataStructure queryDataStructure;

  final QueryPressed queryPressed;

  const QueryElement({super.key, required this.queryPressed, required this.queryDataStructure});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(right: 19, top: 11, bottom: 11),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: GradientBoxBorder(
                gradient: LinearGradient(
                    colors: [
                      ColorsResources.black.withAlpha(137),
                      ColorsResources.premiumDark.withAlpha(0)
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft
                ),
                width: 1,
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(7),
                topLeft: Radius.circular(19),
                bottomRight: Radius.circular(19),
                bottomLeft: Radius.circular(19)
              )
          ),
          child: Padding(
              padding: EdgeInsets.all(11),
              child: InkWell(
                  onLongPress: () {

                    queryPressed(queryDataStructure);

                  },
                  child: Text(
                      queryDataStructure.content()
                  )
              )
          )
      )
    );
  }
}
