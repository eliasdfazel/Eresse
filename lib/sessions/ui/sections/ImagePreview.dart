import 'dart:io';

import 'package:Eresse/resources/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

typedef PreviewPressed = void Function(String element);

class ImagePreview extends StatelessWidget{

  final PreviewPressed previewPressed;

  String imageFile;
  double previewOpacity = 0;

  ImagePreview({super.key, required this.previewPressed, required this.imageFile, required this.previewOpacity});

  @override
  Widget build(BuildContext context) {

    return Visibility(
      visible: (previewOpacity == 0) ? false : true,
      child: AnimatedOpacity(
          opacity: previewOpacity,
          duration: const Duration(milliseconds: 579),
          curve: Curves.easeIn,
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.only(left: 19, right: 19, bottom: 153),
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
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(19),
                          color: ColorsResources.premiumDark.withAlpha(137)
                      ),
                      child: InkWell(
                          splashFactory: NoSplash.splashFactory,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          onTap: () {

                            previewPressed(imageFile);

                          },
                          child: Padding(
                            padding: EdgeInsets.all(13),
                            child: SizedBox(
                                height: 199,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(17),
                                  child: Image(
                                    image: FileImage(File(imageFile)),
                                    height: 199,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                )
                            )
                          )
                      )
                  )
              )
          )
      )
    );
  }

}
