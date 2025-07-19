import 'package:Eresse/resources/colors_resources.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

typedef QueryPressed = void Function(String item);
typedef DecisionPressed = void Function(String item);

class ActionsBar extends StatelessWidget {

  final QueryPressed queryPressed;
  final DecisionPressed decisionPressed;

  ActionsBar({super.key, required this.queryPressed, required this.decisionPressed});

  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(left: 19, right: 19, bottom: 37),
        child: Container(
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
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                            onTap: () => decisionPressed(_textController.text),
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
                        child: TextField(
                          controller: _textController,
                          style: TextStyle(
                            color: ColorsResources.premiumLight
                          ),
                        )
                    ),

                    Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                            onTap: () => decisionPressed(_textController.text),
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
      )
    );
  }
}
