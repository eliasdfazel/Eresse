import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:flutter/material.dart';

typedef SuccessTipPressed = void Function(String element);

class SuccessTip extends StatelessWidget {

  final SuccessTipPressed successTipPressed;

  final String content;

  const SuccessTip({super.key, required this.content, required this.successTipPressed});

  @override
  Widget build(BuildContext context) {

    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: EdgeInsets.only(left: 19, right: 19),
            child: InkWell(
              onTap: () => successTipPressed(content),
              child: Container(
                  height: 173,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    color: ColorsResources.premiumDark.withAlpha(179)
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(19),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          Text(
                            StringsResources.successTipTitle().toUpperCase(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: ColorsResources.premiumLight,
                              fontSize: 19,
                              letterSpacing: 7.3,
                              fontFamily: 'Anurati',
                            ),
                          ),

                          Divider(
                            height: 13,
                            color: Colors.transparent,
                          ),

                          Text(
                            content,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: ColorsResources.premiumLight,
                              fontSize: 15,
                              letterSpacing: 1.73,
                            ),
                          ),

                        ],
                      )
                  )
              )
            )
        )
    );;
  }
}