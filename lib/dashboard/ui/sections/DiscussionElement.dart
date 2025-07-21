import 'package:Eresse/discussions/data/DiscussionDataStructure.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:flutter/material.dart';

typedef DiscussionPressed = void Function(DiscussionDataStructure element);

class DiscussionElement extends StatelessWidget {

  final DiscussionDataStructure discussionDataStructure;

  final DiscussionPressed discussionPressed;

  const DiscussionElement({super.key, required this.discussionDataStructure, required this.discussionPressed});

  @override
  Widget build(BuildContext context) {

    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: EdgeInsets.only(left: 19, right: 19, bottom: 19),
            child: InkWell(
              onTap: () => discussionPressed(discussionDataStructure),
              child: Container(
                  height: 137,
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
                            discussionDataStructure.discussionTitle(),
                            maxLines: 1,
                            style: TextStyle(
                              color: ColorsResources.premiumLight,
                              fontSize: 19,
                              letterSpacing: 1.9,
                            )
                          ),

                          Divider(
                            height: 13,
                            color: Colors.transparent,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Expanded(
                                flex: 1,
                                child: Text(
                                  discussionDataStructure.discussionSummary(),
                                  textAlign: TextAlign.start,
                                  maxLines: 3,
                                  style: TextStyle(
                                    color: ColorsResources.premiumLight,
                                    fontSize: 15,
                                    letterSpacing: 1.73,
                                  ),
                                )
                              ),

                              SizedBox(
                                height: 63,
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                        height: 23,
                                        width: 23,
                                        child: Image(
                                          image: AssetImage("assets/squarcle.png"),
                                          height: 23,
                                          width: 23,
                                          color: discussionDataStructure.statusIndicator(),
                                        )
                                    )
                                )
                              )

                            ],
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