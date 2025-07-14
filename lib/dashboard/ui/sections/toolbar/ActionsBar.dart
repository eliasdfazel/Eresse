import 'package:Eresse/resources/colors_resources.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

typedef Pressed = void Function(String item);

class ActionsBar extends StatelessWidget {

  final Pressed onPressed;

  ActionsBar({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(left: 19, right: 19, bottom: 73),
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
            borderRadius: BorderRadius.circular(19)
          ),
          child: Blur(
            blur: 13,
            borderRadius: BorderRadius.circular(19),
            blurColor: ColorsResources.premiumDark,
            colorOpacity: 0.73,
            overlay: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 51,
                        height: 51,
                        color: ColorsResources.cyan,
                      )
                  ),

                  Expanded(
                      flex: 1,
                      child: Container(
                        width: 51,
                        height: 75,
                        color: ColorsResources.premiumLight.withAlpha(1),
                      )
                  ),

                  Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 51,
                        height: 51,
                        color: ColorsResources.cyan,
                      )
                  ),

                ]
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
