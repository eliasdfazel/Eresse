import 'package:Eresse/resources/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:shaped_image/shaped_image.dart';

typedef Pressed = void Function(String element);

class NextedButtons extends StatelessWidget {

  final Pressed onPressed;

  String buttonTag;

  /// assets/XYZ.png
  /// https://...
  String imageResources;
  bool imageNetwork;

  BoxFit boxFit;
  double paddingInset;

  NextedButtons({super.key, required this.buttonTag, required this.onPressed, required this.imageResources, required this.imageNetwork, required this.boxFit, required this.paddingInset});

  @override
  Widget build(BuildContext context) {

    ImageType imageType = ImageType.ASSET;

    if (imageNetwork) {
      imageType = ImageType.NETWORK;
    } else {
      imageType = ImageType.ASSET;
    }

    return SizedBox(
        height: 51,
        width: 51,
        child: InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          borderRadius: BorderRadius.circular(19),
          onTap: () => onPressed(buttonTag),
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
                        child: ShapedImage(
                          imageTye: imageType,
                          path: imageResources,
                          shape: Shape.Squarcle,
                          height: 49,
                          width: 49,
                        )
                    )
                )

              ]
          )
        )
    );
  }
}
