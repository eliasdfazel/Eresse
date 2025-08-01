import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

typedef QueryPressed = void Function(String element);
typedef DecisionPressed = void Function(String element);
typedef InputPressed = void Function();

class ActionsBar extends StatelessWidget {

  final QueryPressed queryPressed;
  final DecisionPressed decisionPressed;
  final InputPressed inputPressed;

  ActionsBar({super.key, required this.queryPressed, required this.decisionPressed, required this.inputPressed});

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Positioned(
      bottom: 51,
      left: 19,
      right: 19,
      child: Container(
          height: 75,
          width: double.infinity,
          decoration: BoxDecoration(
              border: GradientBoxBorder(
                gradient: LinearGradient(
                    colors: [
                      ColorsResources.premiumDark.withAlpha(199),
                      ColorsResources.premiumDark.withAlpha(0),
                      ColorsResources.premiumDark.withAlpha(199),
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
              colorOpacity: 0.37,
              overlay: Padding(
                  padding: EdgeInsets.only(left: 11, right: 11),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                                onTap: () {

                                  decisionPressed(_textController.text);

                                },
                                child: SizedBox(
                                    width: 51,
                                    height: 51,
                                    child: Image(
                                      image: AssetImage("assets/decision.png"),
                                    )
                                )
                            )
                        ),

                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(left: 13, right: 13),
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: _textController,
                                cursorRadius: Radius.circular(99),
                                autofocus: false,
                                cursorColor: ColorsResources.primaryColor,
                                minLines: 1,
                                maxLines: null,
                                onTap: () {

                                  inputPressed();

                                },
                                style: TextStyle(
                                  color: ColorsResources.premiumLight,
                                  fontSize: 19,
                                  height: 1.51,
                                  overflow: TextOverflow.fade
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: StringsResources.expressIdeaTitle(),
                                    hintMaxLines: 1,
                                    hintFadeDuration: const Duration(milliseconds: 357),
                                    hintStyle: TextStyle(
                                        color: ColorsResources.premiumLight.withAlpha(137),
                                        fontSize: 19
                                    )
                                ),
                              )
                            )
                        ),

                        Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                                onTap: () {

                                  queryPressed(_textController.text);

                                },
                                child: SizedBox(
                                    width: 51,
                                    height: 51,
                                    child: Image(
                                      image: AssetImage("assets/query.png"),
                                    )
                                )
                            )
                        ),

                      ]
                  )
              ),
              child: SizedBox(
                  height: 75,
                  width: double.infinity
              )
          )
      )
    );
  }
}
