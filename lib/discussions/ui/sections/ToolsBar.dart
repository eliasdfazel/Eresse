import 'package:flutter/material.dart';

typedef ArchivePressed = void Function(String item);
typedef AskPressed = void Function(String item);

class ToolsBar extends StatelessWidget {

  final ArchivePressed archivePressed;
  final AskPressed askPressed;

  ToolsBar({super.key, required this.archivePressed, required this.askPressed});

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(left: 19, right: 19, bottom: 137),
        child: Container(
          height: 75,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
          ),
          child: Padding(
              padding: EdgeInsets.only(left: 11, right: 11),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                            onTap: () => askPressed(_textController.text),
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
                            onTap: () => askPressed(_textController.text),
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
        )
      )
    );
  }
}
