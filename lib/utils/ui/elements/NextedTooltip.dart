import 'package:Eresse/resources/colors_resources.dart';
import 'package:flutter/material.dart';

Widget nextedTooltip(String inputContent, Widget inputWidget) {

  return Tooltip(
    message: inputContent,
    preferBelow: false,
    verticalOffset: 51,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: ColorsResources.premiumDark.withAlpha(137)
    ),
    textStyle: TextStyle(
        color: ColorsResources.premiumLight,
        fontSize: 13
    ),
    child: inputWidget
  );
}