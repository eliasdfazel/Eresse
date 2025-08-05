import 'dart:io';

import 'package:Eresse/database/json/DialoguesJSON.dart';
import 'package:Eresse/database/structures/DialogueDataStructure.dart';
import 'package:Eresse/database/structures/DialogueSqlDataStructure.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

typedef DecisionPressed = void Function(DialogueSqlDataStructure queryDataStructure);

class DecisionElement extends StatelessWidget {

  final DialoguesJSON dialoguesJSON;

  final DialogueSqlDataStructure queryDataStructure;

  final DecisionPressed decisionPressed;

  const DecisionElement({super.key, required this.decisionPressed, required this.queryDataStructure, required this.dialoguesJSON});

  @override
  Widget build(BuildContext context) {

    final textMessage = dialoguesJSON.messageMap(queryDataStructure.getContent())[MessageContent.textMessage.name];

    final imageMessage = dialoguesJSON.messageMap(queryDataStructure.getContent())[MessageContent.imageMessage.name];

    return Container(
      padding: EdgeInsets.only(left: 19, top: 11, bottom: 11),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(19),
                  topLeft: Radius.circular(11),
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
                          ColorsResources.decisionColor,
                          ColorsResources.decisionColor.withAlpha(0)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight
                    ),
                    width: 1.37,
                  ),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(19),
                      topLeft: Radius.circular(11),
                      bottomRight: Radius.circular(19),
                      bottomLeft: Radius.circular(19)
                  ),
                  gradient: RadialGradient(
                      colors: [
                        ColorsResources.decisionColor.withAlpha(37),
                        ColorsResources.decisionColor.withAlpha(0)
                      ],
                      center: Alignment.topLeft,
                      radius: 3
                  )
              ),
              child: Padding(
                  padding: EdgeInsets.all(11),
                  child: InkWell(
                      onLongPress: () {

                        decisionPressed(queryDataStructure);

                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          (textMessage == null) ? Container() : Text(
                            textMessage,
                            style: TextStyle(
                                color: ColorsResources.premiumLight,
                                fontSize: 13
                            ),
                          ),

                          (imageMessage == null || imageMessage.isEmpty) ? Container() :
                            Padding(
                                padding: EdgeInsets.only(top: 13, left: 7, right: 7, bottom: 7),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(17),
                                  child: Image(
                                    image: FileImage(File(imageMessage)),
                                    height: 199,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                              )
                            )

                        ]
                      )
                  )
              )
          )
        )
      )
    );
  }
}
