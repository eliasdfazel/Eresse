import 'package:Eresse/discussions/data/QueryDataStructure.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:blur/blur.dart';
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

    return Container(
        height: 75,
        width: double.infinity,
        decoration: BoxDecoration(
            border: GradientBoxBorder(
              gradient: LinearGradient(
                  colors: [
                    ColorsResources.black.withAlpha(137),
                    ColorsResources.premiumDark.withAlpha(0),
                    ColorsResources.black.withAlpha(137),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
              ),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(19),
            boxShadow: [
              BoxShadow(
                  color: ColorsResources.black.withAlpha(73),
                  blurRadius: 37,
                  offset: const Offset(0, 19)
              )
            ]
        ),
        child: Blur(
            blur: 19,
            borderRadius: BorderRadius.circular(19),
            blurColor: ColorsResources.premiumDark,
            colorOpacity: 0.73,
            overlay: Padding(
                padding: EdgeInsets.only(left: 11, right: 11),
                child: InkWell(
                  onLongPress: () {

                    queryPressed(queryDataStructure);

                  },
                  child: Text(
                    queryDataStructure.content()
                  )
                )
            ),
            child: SizedBox(
                height: 75,
                width: double.infinity
            )
        )
    );
  }
}
