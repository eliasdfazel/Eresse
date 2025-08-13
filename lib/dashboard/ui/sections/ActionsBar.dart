import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:Eresse/utils/ui/elements/NextedTooltip.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

typedef StartPressed = void Function();
typedef ArchivePressed = void Function();
typedef SearchPressed = void Function();

class ActionsBar extends StatelessWidget {

  final StartPressed startPressed;
  final ArchivePressed archivePressed;
  final SearchPressed searchPressed;

  const ActionsBar({super.key, required this.startPressed, required this.archivePressed, required this.searchPressed});

  @override
  Widget build(BuildContext context) {

    return Positioned(
      bottom: 51,
      left: 19,
      right: 19,
      child: Container(
          height: 75,
          width: double.infinity,
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
                width: 1
              ),
              borderRadius: BorderRadius.circular(19),
              boxShadow: [
                BoxShadow(
                    color: ColorsResources.black.withAlpha(73),
                    blurRadius: 37,
                    offset: const Offset(0, 19)
                )
              ]
          ),
          child: Blur(
              blur: 19,
              borderRadius: BorderRadius.circular(19),
              blurColor: ColorsResources.premiumDark,
              colorOpacity: 0.37,
              overlay: Padding(
                  padding: EdgeInsets.only(left: 11, right: 11),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                                splashFactory: NoSplash.splashFactory,
                                onTap: () => archivePressed(),
                                child: nextedTooltip(
                                    StringsResources.archivesTooltip(),
                                    SizedBox(
                                        width: 51,
                                        height: 51,
                                        child: Image(
                                          image: AssetImage("assets/archive.png"),
                                        )
                                    )
                                )
                            )
                        ),

                        Expanded(
                            flex: 1,
                            child: InkWell(
                                splashFactory: NoSplash.splashFactory,
                                onTap: () => startPressed(),
                                child: Padding(
                                    padding: EdgeInsets.only(left: 19, right: 19),
                                    child: SizedBox(
                                        height: 75,
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                                width: 113,
                                                child: Image(
                                                  image: AssetImage("assets/start.png"),
                                                  fit: BoxFit.contain,
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                        ),

                        Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                                splashFactory: NoSplash.splashFactory,
                                onTap: () => searchPressed(),
                                child: nextedTooltip(
                                    StringsResources.searchTooltip(),
                                    SizedBox(
                                    width: 51,
                                    height: 51,
                                    child: Image(
                                      image: AssetImage("assets/search.png"),
                                    )
                                )
                                )
                            )
                        ),

                      ]
                  )
              ),
              child: SizedBox(
                  height: 75,
                  width: double.infinity
              )
          )
      )
    );
  }
}
