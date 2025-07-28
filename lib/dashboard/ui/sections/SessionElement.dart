import 'package:Eresse/database/structures/SessionSqlDataStructure.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:flutter/material.dart';

typedef SessionPressed = void Function(SessionSqlDataStructure element);

class SessionElement extends StatelessWidget {

  final SessionSqlDataStructure sessionDataStructure;

  final SessionPressed sessionPressed;

  const SessionElement({super.key, required this.sessionDataStructure, required this.sessionPressed});

  @override
  Widget build(BuildContext context) {

    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: EdgeInsets.only(left: 19, right: 19, bottom: 19),
            child: InkWell(
              onTap: () => sessionPressed(sessionDataStructure),
              child: Container(
                  height: 137,
                  width: double.infinity,
                  decoration: BoxDecoration(
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
                            sessionDataStructure.getSessionTitle(),
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
                                  sessionDataStructure.getSessionSummary(),
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
                                          color: sessionDataStructure.statusIndicatorColor(),
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