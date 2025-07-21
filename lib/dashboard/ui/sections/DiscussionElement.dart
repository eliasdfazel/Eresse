import 'package:Eresse/discussions/data/DiscussionDataStructure.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
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
            padding: EdgeInsets.only(left: 19, right: 19),
            child: InkWell(
              onTap: () => discussionPressed(discussionDataStructure),
              child: Container(
                  height: 173,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
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
                            discussionDataStructure.documentId(),
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