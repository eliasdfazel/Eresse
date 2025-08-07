import 'package:Eresse/resources/colors_resources.dart';
import 'package:flutter/material.dart';

Widget entryDecorations() {

  return Stack(
    children: [

      Align(
          alignment: Alignment.center,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: SweepGradient(
                    colors: [
                      ColorsResources.primaryColor,
                      ColorsResources.primaryColorLight
                    ],
                    center: Alignment.topLeft
                )
            ),
            child: Image(
              image: AssetImage('assets/texture.png'),
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
      ),

      Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: 173,
                minHeight: 173,
                maxWidth: 313,
                maxHeight: 313
            ),
            child: Image(
              image: AssetImage('assets/logo.png'),
            ),
          )
      )

    ],
  );
}

Widget decorations({int backgroundOpacity = 199, double textureOpacity = 0.73, double brandingOpacity = 0.73}) {

  return Stack(
    children: [

      Align(
          alignment: Alignment.center,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: SweepGradient(
                  colors: [
                    ColorsResources.primaryColor.withAlpha(backgroundOpacity),
                    ColorsResources.primaryColorLight.withAlpha(backgroundOpacity)
                  ],
                  center: Alignment.topLeft
              )
            ),
            child: Opacity(
              opacity: textureOpacity,
              child: Image(
                  image: AssetImage('assets/texture.png'),
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover
              )
            )
          )
      ),

      Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: 173,
                minHeight: 173,
                maxWidth: 313,
                maxHeight: 313
            ),
            child: Opacity(
              opacity: brandingOpacity,
              child: Image(
                image: AssetImage('assets/logo_blur.png'),
              )
            )
          )
      )

    ],
  );
}