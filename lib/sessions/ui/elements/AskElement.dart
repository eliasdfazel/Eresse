import 'package:Eresse/database/json/DialoguesJSON.dart';
import 'package:Eresse/database/structures/DialogueDataStructure.dart';
import 'package:Eresse/database/structures/DialogueSqlDataStructure.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

typedef AskPressed = void Function(DialogueSqlDataStructure queryDataStructure);

class AskElement extends StatelessWidget {

  final DialoguesJSON dialoguesJSON;

  final DialogueSqlDataStructure queryDataStructure;

  final AskPressed askPressed;

  const AskElement({super.key, required this.askPressed, required this.queryDataStructure, required this.dialoguesJSON});

  @override
  Widget build(BuildContext context) {

    final textMessage = dialoguesJSON.messageMap(queryDataStructure.getContent())[MessageContent.textMessage.name];

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
              gradient: LinearGradient(
                  colors: [
                    ColorsResources.premiumDark.withAlpha(159),
                    ColorsResources.premiumDark.withAlpha(137),
                    ColorsResources.premiumDark.withAlpha(159),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
              )
          ),
          child: Padding(
              padding: EdgeInsets.all(11),
              child: InkWell(
                  onLongPress: () {

                    askPressed(queryDataStructure);

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

                        // if content is image add image widget
                        // or text

                      ]
                  )
              )
          )
      )
    );
  }
}
