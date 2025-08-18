import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

typedef SuccessTipPressed = void Function(String element);

class SuccessTip extends StatefulWidget {

  final SuccessTipPressed successTipPressed;

  final String content;

  Color topLeftColor = ColorsResources.premiumDark.withAlpha(179);
  Color centerColor = ColorsResources.premiumDark.withAlpha(0);
  Color bottomRightColor = ColorsResources.premiumDark.withAlpha(179);

  SuccessTip({super.key, required this.content, required this.successTipPressed, required this.topLeftColor, required this.centerColor, required this.bottomRightColor});

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
        child: InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onLongPress: () => widget.successTipPressed(widget.content),
            child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    Padding(
                        padding: EdgeInsets.only(left: 37, right: 37),
                        child: Text(
                          StringsResources.successTipTitle().toUpperCase(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: ColorsResources.premiumLight.withAlpha(179),
                            fontSize: 15,
                            letterSpacing: 3.7,
                            fontFamily: 'Anurati',
                          ),
                        )
                    ),

                    Divider(
                      height: 11,
                      color: Colors.transparent,
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 19, right: 19),
                      child: Container(
                          decoration: BoxDecoration(
                              border: GradientBoxBorder(
                                  gradient: LinearGradient(
                                      colors: [
                                        widget.topLeftColor,
                                        widget.centerColor,
                                        widget.bottomRightColor,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight
                                  ),
                                  width: 1
                              ),
                              borderRadius: BorderRadius.circular(19),
                              color: ColorsResources.premiumDark.withAlpha(37)
                          ),
                          padding: EdgeInsets.only(left: 19, right: 19, top: 13, bottom: 13),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [

                                Text(
                                  widget.content,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: ColorsResources.premiumLight,
                                    fontSize: 15,
                                    letterSpacing: 1,
                                  ),
                                ),

                                Divider(
                                  height: 13,
                                  color: Colors.transparent,
                                ),

                                Container(
                                    height: 31,
                                    width: 31,
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                        splashFactory: NoSplash.splashFactory,
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        onTap: () => widget.successTipPressed(widget.content),
                                        child: Image(
                                          image: AssetImage('assets/share.png'),
                                        )
                                    )
                                )

                              ]
                          )
                      )
                    )

                  ],
                )
            )
        )
    );
  }

}
