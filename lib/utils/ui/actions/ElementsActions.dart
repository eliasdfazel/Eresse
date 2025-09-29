import 'package:flutter/material.dart';

void scrollToStart(ScrollController scrollController) {

  Future.delayed(const Duration(milliseconds: 777), () {

    scrollController.animateTo(0, duration: const Duration(milliseconds: 137), curve: Curves.easeOut);

  });

}

void scrollToEnd(ScrollController scrollController) {

  Future.delayed(const Duration(milliseconds: 777), () {

    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 137), curve: Curves.easeOut);

  });

}