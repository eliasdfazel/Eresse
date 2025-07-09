

import 'package:flutter/material.dart';

Widget entryDecorations() {

  return /* START - Decoration */
    Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: 173,
              minHeight: 173,
              maxWidth: 373,
              maxHeight: 373
          ),
          child: Image(
            image: AssetImage('assets/logo.png'),
          ),
        )
    )
  /* END - Decoration */;
}

Widget decorations() {

  return /* START - Decoration */
    Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: 173,
              minHeight: 173,
              maxWidth: 373,
              maxHeight: 373
          ),
          child: Image(
            image: AssetImage('assets/logo_blur.png'),
          ),
        )
    )
  /* END - Decoration */;
}