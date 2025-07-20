import 'package:Eresse/resources/colors_resources.dart';
import 'package:flutter/material.dart';

typedef ArchivePressed = void Function(String item);
typedef AskPressed = void Function(String item);

class Toolbar extends StatefulWidget {

  final ArchivePressed archivePressed;
  final AskPressed askPressed;

  const Toolbar({super.key, required this.archivePressed, required this.askPressed});

  @override
  State<Toolbar> createState() => _Toolbar();
}
class _Toolbar extends State<Toolbar> {

  final TextEditingController _textController = TextEditingController();

  double toolbarOpacity = 0;

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(left: 19, right: 19, bottom: 123),
        child: Container(
          height: 83,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
          ),
          child: Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(left: 11, right: 11),
              child: Column(
                children: [

                  AnimatedOpacity(
                    opacity: toolbarOpacity,
                    duration: const Duration(milliseconds: 375),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                  onTap: () {

                                    widget.askPressed(_textController.text);

                                    setState(() {

                                      toolbarOpacity = 0;

                                    });

                                  },
                                  child: SizedBox(
                                      width: 51,
                                      height: 51,
                                      child: Image(
                                        image: AssetImage("assets/archive.png"),
                                      )
                                  )
                              )
                          ),

                          Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                  onTap: () {

                                    widget.askPressed(_textController.text);

                                    setState(() {

                                      toolbarOpacity = 0;

                                    });

                                  },
                                  child: SizedBox(
                                      width: 51,
                                      height: 51,
                                      child: Image(
                                        image: AssetImage("assets/ask.png"),
                                      )
                                  )
                              )
                          ),

                        ]
                    )
                  ),

                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 13, bottom: 13),
                      child: InkWell(
                          onTap: () {

                            setState(() {

                              toolbarOpacity = (toolbarOpacity == 1) ? 0 : 1;

                            });

                          },
                          child: SizedBox(
                            height: 5,
                            child: Image(
                              image: AssetImage("assets/menu.png"),
                              height: 5,
                              fit: BoxFit.contain,
                              color: ColorsResources.premiumDark,
                            )
                          )
                      )
                  ),

                ],
              )
          ),
        )
      )
    );
  }
}
