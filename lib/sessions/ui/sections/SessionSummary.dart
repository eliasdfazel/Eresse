import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class SessionSummary extends StatefulWidget {

  final String content;

  SessionSummary({super.key, required this.content});

  @override
  State<SessionSummary> createState() => _SessionSummaryState();

}
class _SessionSummaryState extends State<SessionSummary> {

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

    return (widget.content.isEmpty)
        ? Container() : Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Padding(
                    padding: EdgeInsets.only(left: 37, right: 37),
                    child: Text(
                      StringsResources.summaryTitle().toUpperCase(),
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
                                      ColorsResources.premiumDark.withAlpha(199),
                                      ColorsResources.premiumDark.withAlpha(0),
                                      ColorsResources.premiumDark.withAlpha(199),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight
                                ),
                                width: 1.73
                            ),
                            borderRadius: BorderRadius.circular(19),
                            color: ColorsResources.premiumDark.withAlpha(19)
                        ),
                        padding: EdgeInsets.only(left: 19, right: 19, top: 25, bottom: 25),
                        child: Text(
                          widget.content,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: ColorsResources.premiumLight,
                            fontSize: 15,
                            letterSpacing: 1,
                          ),
                        )
                    )
                )

              ],
            )
        )
    );
  }

}
