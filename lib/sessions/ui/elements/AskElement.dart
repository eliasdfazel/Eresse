import 'dart:io';

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

    return FutureBuilder(
      future: _dataFuture(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, String?>> dataSnapshot) {

        if (dataSnapshot.connectionState == ConnectionState.done) {

          return  Container(
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
                            ColorsResources.premiumDark.withAlpha(99),
                            ColorsResources.premiumDark.withAlpha(37),
                            ColorsResources.premiumDark.withAlpha(99),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight
                      )
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(11),
                      child: InkWell(
                          splashFactory: NoSplash.splashFactory,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          onLongPress: () {

                            askPressed(queryDataStructure);

                          },
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                (dataSnapshot.data?[MessageContent.textMessage.name] == null) ? Container() :
                                Text(
                                  dataSnapshot.data![MessageContent.textMessage.name]!,
                                  style: TextStyle(
                                      color: ColorsResources.premiumLight,
                                      fontSize: 13
                                  ),
                                ),

                                (dataSnapshot.data?[MessageContent.imageMessage.name] == null || dataSnapshot.data![MessageContent.imageMessage.name]!.isEmpty) ? Container() :
                                Padding(
                                    padding: EdgeInsets.only(top: 13),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(17),
                                        child: Image(
                                          image: FileImage(File(dataSnapshot.data![MessageContent.imageMessage.name]!)),
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
          );

        } else {

          return Container();
        }
      },
    );
  }

  Future<Map<String, String?>> _dataFuture() async {

    final textMessage = (await dialoguesJSON.messageExtract(queryDataStructure.getContent()))[MessageContent.textMessage.name];

    final imageMessage = (await dialoguesJSON.messageExtract(queryDataStructure.getContent()))[MessageContent.imageMessage.name];

    return {
      MessageContent.textMessage.name: textMessage,
      MessageContent.imageMessage.name: imageMessage
    };
  }

}
