import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

typedef SuccessTipPressed = void Function(String element);

class SuccessTip extends StatefulWidget {

  final SuccessTipPressed successTipPressed;

  final String content;

  const SuccessTip({super.key, required this.content, required this.successTipPressed});

  @override
  State<SuccessTip> createState() => _SuccessTipState();

}
class _SuccessTipState extends State<SuccessTip> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: EdgeInsets.only(left: 19, right: 19),
            child: InkWell(
                onTap: () => widget.successTipPressed(widget.content),
                child: Container(
                    height: 173,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: GradientBoxBorder(
                            gradient: LinearGradient(
                                colors: [
                                  ColorsResources.premiumDark.withAlpha(179),
                                  ColorsResources.premiumDark.withAlpha(0),
                                  ColorsResources.premiumDark.withAlpha(179),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight
                            ),
                            width: 1
                        ),
                        borderRadius: BorderRadius.circular(19),
                        color: ColorsResources.premiumDark.withAlpha(103)
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
                              widget.content,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: ColorsResources.premiumLight,
                                fontSize: 15,
                                letterSpacing: 1,
                              ),
                            ),

                          ],
                        )
                    )
                )
            )
        )
    );
  }

}
