import 'package:Eresse/discussions/data/DialogueDataStructure.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

typedef AskPressed = void Function(DialogueDataStructure queryDataStructure);

class AskElement extends StatelessWidget {

  final DialogueDataStructure queryDataStructure;

  final AskPressed askPressed;

  const AskElement({super.key, required this.askPressed, required this.queryDataStructure});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(left: 19, right: 19, top: 11, bottom: 11),
      alignment: Alignment.centerLeft,
      child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
              minHeight: 73
          ),
          decoration: BoxDecoration(
              border: GradientBoxBorder(
                gradient: LinearGradient(
                    colors: [
                      ColorsResources.premiumDark,
                      ColorsResources.premiumDark.withAlpha(0),
                      ColorsResources.premiumDark,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight
                ),
                width: 1.73,
              ),
              borderRadius: BorderRadius.all(Radius.circular(19)),
              color: ColorsResources.premiumDark.withAlpha(199),
          ),
          child: Padding(
              padding: EdgeInsets.all(11),
              child: InkWell(
                  onLongPress: () {

                    askPressed(queryDataStructure);

                  },
                  child: Text(
                    queryDataStructure.content(),
                    style: TextStyle(
                        color: ColorsResources.premiumLight,
                        fontSize: 13
                    ),
                  )
              )
          )
      )
    );
  }
}
