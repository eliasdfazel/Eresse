import 'package:flutter/material.dart';

void scrollToEnd(ScrollController scrollController) {

  Future.delayed(const Duration(milliseconds: 777), () {

    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 137), curve: Curves.easeOut);

  });

}