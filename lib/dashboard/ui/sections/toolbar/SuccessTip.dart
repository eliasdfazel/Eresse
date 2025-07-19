import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';

class SuccessTip extends StatelessWidget {

  final String content;

  SuccessTip({super.key, required this.content});

  @override
  Widget build(BuildContext context) {

    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: EdgeInsets.only(left: 19, right: 19),
            child: Container(
                height: 173,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                ),
                child: Blur(
                    blur: 19,
                    borderRadius: BorderRadius.circular(19),
                    blurColor: ColorsResources.premiumDark,
                    colorOpacity: 0.73,
                    overlay: Padding(
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
                    ),
                    child: SizedBox(
                        height: 173,
                        width: double.infinity
                    )
                )
            )
        )
    );;
  }
}