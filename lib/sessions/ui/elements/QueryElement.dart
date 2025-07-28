import 'package:Eresse/database/structures/DialogueSqlDataStructure.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

typedef QueryPressed = void Function(DialogueSqlDataStructure queryDataStructure);

class QueryElement extends StatelessWidget {

  final DialogueSqlDataStructure queryDataStructure;

  final QueryPressed queryPressed;

  const QueryElement({super.key, required this.queryPressed, required this.queryDataStructure});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(right: 19, top: 11, bottom: 11),
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: Container(
          decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(11),
                    topLeft: Radius.circular(19),
                    bottomRight: Radius.circular(19),
                    bottomLeft: Radius.circular(19)
                ),
                color: ColorsResources.premiumDark.withAlpha(199)
            ),
          child: Container(
              constraints: BoxConstraints(
                  minHeight: 73
              ),
              decoration: BoxDecoration(
                  border: GradientBoxBorder(
                    gradient: LinearGradient(
                        colors: [
                          ColorsResources.queryColor,
                          ColorsResources.queryColor.withAlpha(0)
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft
                    ),
                    width: 1.73,
                  ),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(11),
                      topLeft: Radius.circular(19),
                      bottomRight: Radius.circular(19),
                      bottomLeft: Radius.circular(19)
                  ),
                  gradient: LinearGradient(
                      colors: [
                        ColorsResources.queryColor.withAlpha(37),
                        ColorsResources.queryColor.withAlpha(0)
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft
                  )
              ),
              child: Padding(
                  padding: EdgeInsets.all(11),
                  child: InkWell(
                      onLongPress: () {

                        queryPressed(queryDataStructure);

                      },
                      child: Text(
                        queryDataStructure.getContent(),
                        style: TextStyle(
                            color: ColorsResources.premiumLight,
                            fontSize: 13
                        ),
                      )
                  )
              )
          )
        )
      )
    );
  }
}
