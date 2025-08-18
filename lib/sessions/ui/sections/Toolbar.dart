import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:Eresse/utils/ui/elements/NextedTooltip.dart';
import 'package:flutter/material.dart';

typedef ArchivePressed = void Function();
typedef DeletePressed = void Function();
typedef ImageSelectorPressed = void Function();
typedef AskPressed = void Function(String element);

class Toolbar extends StatefulWidget {

  final ArchivePressed archivePressed;
  final DeletePressed deletePressed;
  final ImageSelectorPressed imageSelectorPressed;
  final AskPressed askPressed;

  double toolbarOpacity = 0;

  final TextEditingController textController;

  Toolbar({super.key, required this.archivePressed, required this.imageSelectorPressed, required this.askPressed, required this.deletePressed,
    required this.textController, required this.toolbarOpacity});

  @override
  State<Toolbar> createState() => _Toolbar();
}
class _Toolbar extends State<Toolbar> {

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
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  Visibility(
                    visible: (widget.toolbarOpacity == 0) ? false : true,
                    child: AnimatedOpacity(
                        opacity: widget.toolbarOpacity,
                        duration: const Duration(milliseconds: 777),
                        curve: Curves.easeIn,
                        child: Row(
                            spacing: 19,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              /*
                               * START - Delete
                               */
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                      splashFactory: NoSplash.splashFactory,
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      borderRadius: BorderRadius.circular(19),
                                      onTap: () {

                                        widget.deletePressed();

                                        setState(() {

                                          widget.toolbarOpacity = 0;

                                        });

                                      },
                                      child: nextedTooltip(
                                          StringsResources.deleteTitle(),
                                          SizedBox(
                                              width: 51,
                                              height: 51,
                                              child: Image(
                                                image: AssetImage("assets/close.png"),
                                              )
                                          )
                                      )
                                  )
                              ),
                              /*
                               * END - Delete
                               */

                              Spacer(),

                              /*
                               * START - Archive
                               */
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                      splashFactory: NoSplash.splashFactory,
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      borderRadius: BorderRadius.circular(19),
                                      onTap: () {

                                        widget.archivePressed();

                                        setState(() {

                                          widget.toolbarOpacity = 0;

                                        });

                                      },
                                      child: nextedTooltip(
                                          StringsResources.archivesTitle(),
                                          SizedBox(
                                              width: 51,
                                              height: 51,
                                              child: Image(
                                                image: AssetImage("assets/save.png"),
                                              )
                                          )
                                      )
                                  )
                              ),
                              /*
                               * END - Archive
                               */

                              /*
                               * START - Image
                               */
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                      splashFactory: NoSplash.splashFactory,
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      borderRadius: BorderRadius.circular(19),
                                      onTap: () {

                                        widget.imageSelectorPressed();

                                        setState(() {

                                          widget.toolbarOpacity = 0;

                                        });

                                      },
                                      child: nextedTooltip(
                                          StringsResources.imageTitle(),
                                          SizedBox(
                                              width: 51,
                                              height: 51,
                                              child: Image(
                                                image: AssetImage("assets/image.png"),
                                              )
                                          )
                                      )
                                  )
                              ),
                              /*
                               * END - Image
                               */

                              /*
                               * START - Ask
                               */
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                      splashFactory: NoSplash.splashFactory,
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      borderRadius: BorderRadius.circular(19),
                                      onTap: () {

                                        widget.askPressed(widget.textController.text);

                                        setState(() {

                                          widget.toolbarOpacity = 0;

                                        });

                                      },
                                      child: nextedTooltip(
                                          StringsResources.askTitle(),
                                          SizedBox(
                                              width: 51,
                                              height: 51,
                                              child: Image(
                                                image: AssetImage("assets/ask.png"),
                                              )
                                          )
                                      )
                                  )
                              ),
                              /*
                               * END - Ask
                               */

                            ]
                        )
                    )
                  ),

                  InkWell(
                      borderRadius: BorderRadius.circular(19),
                      splashFactory: NoSplash.splashFactory,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {

                        showToolbar();

                      },
                      child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 13, bottom: 13),
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
                  )

                ],
              )
          ),
        )
      )
    );
  }

  void showToolbar() {

    setState(() {

      widget.toolbarOpacity = (widget.toolbarOpacity == 1) ? 0 : 1;

    });

  }

}
