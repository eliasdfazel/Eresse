import 'package:Eresse/resources/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';

class NextedButtons extends StatelessWidget {

  final VoidCallback onTap;

  String buttonTag;

  /// assets/XYZ.png
  /// https://...
  String imageResources;
  bool imageNetwork;

  BoxFit boxFit;

  NextedButtons({super.key, required this.buttonTag, required this.onTap, required this.imageResources, required this.imageNetwork, required this.boxFit});

  @override
  Widget build(BuildContext context) {

    ImageProvider imageProvider = AssetImage("assets/logo.png");

    if (imageNetwork) {
      imageProvider = NetworkImage(imageResources);
    } else {
      imageProvider = AssetImage(imageResources);
    }

    return SizedBox(
        height: 51,
        width: 51,
        child: Stack(
            children: [

              const Image(
                image: AssetImage("assets/squarcle.png"),
                height: 51,
                width: 51,
                color: ColorsResources.premiumLight,
              ),

              Align(
                alignment: Alignment.center,
                child: const Image(
                  image: AssetImage("assets/squarcle.png"),
                  height: 49,
                  width: 49,
                  color: ColorsResources.primaryColor,
                ),
              ),

              Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      height: 49,
                      width: 49,
                      child: Material(
                        shadowColor: Colors.transparent,
                        color: Colors.transparent,
                        child: InkWell(
                            splashColor: ColorsResources.premiumLight.withAlpha(73),
                            splashFactory: InkRipple.splashFactory,
                            onTap: onTap,
                            child: WidgetMask(
                              blendMode: BlendMode.dstATop,
                              childSaveLayer: true,
                              mask: const Image(
                                image: AssetImage("assets/squarcle.png"),
                                height: 49,
                                width: 49,
                              ),
                              child: Image(
                                image: imageProvider,
                                fit: boxFit,
                              )
                            )
                        ),
                      )
                  )
              )

            ]
        )
    );
  }
}
