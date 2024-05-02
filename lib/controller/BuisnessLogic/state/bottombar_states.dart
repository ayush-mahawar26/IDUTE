import 'package:flutter/material.dart';

abstract class LandingPageState {
  int tabIndex;

  LandingPageState({required this.tabIndex});
}

class LandingPageInitial extends LandingPageState {
  LandingPageInitial({required super.tabIndex});
}
