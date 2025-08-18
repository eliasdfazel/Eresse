import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:Eresse/utils/ui/elements/NextedTooltip.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

typedef ClosePressed = void Function();
typedef SearchPressed = void Function(String searchQuery);

class NextedSearchBar extends StatelessWidget {

  final ClosePressed closePressed;
  final SearchPressed searchPressed;

  final TextEditingController textController;

  const NextedSearchBar({super.key, required this.closePressed, required this.searchPressed, required this.textController});

  @override
  Widget build(BuildContext context) {

    return Container(
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
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onTap: () => closePressed(),
                              child: nextedTooltip(
                                  StringsResources.searchClose(),
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

                      Expanded(
                          flex: 1,
                          child: Container(
                              padding: EdgeInsets.only(left: 13, right: 13),
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: textController,
                                cursorRadius: Radius.circular(99),
                                autofocus: true,
                                cursorColor: ColorsResources.primaryColor,
                                minLines: 1,
                                maxLines: null,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (searchQuery) {

                                  searchPressed(textController.text);

                                },
                                style: TextStyle(
                                    color: ColorsResources.premiumLight,
                                    fontSize: 19,
                                    height: 1.51,
                                    overflow: TextOverflow.fade
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: StringsResources.searchTooltip(),
                                    hintMaxLines: 1,
                                    hintFadeDuration: const Duration(milliseconds: 357),
                                    hintStyle: TextStyle(
                                        color: ColorsResources.premiumLight.withAlpha(137),
                                        fontSize: 19
                                    )
                                ),
                              )
                          )
                      ),

                      Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                              splashFactory: NoSplash.splashFactory,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onTap: () => searchPressed(textController.text),
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
    );
  }
}
