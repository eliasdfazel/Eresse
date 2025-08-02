

import 'package:flutter/material.dart';

Widget entryDecorations() {

  return Stack(
    children: [

      Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              image: AssetImage('assets/decoration_background.jpg'),
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

Widget decorations({double backgroundOpacity = 1, double brandingOpacity = 1}) {

  return Stack(
    children: [

      Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Opacity(
              opacity: backgroundOpacity,
              child: Image(
                  image: AssetImage('assets/decoration_background.jpg'),
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