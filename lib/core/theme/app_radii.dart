import 'package:flutter/material.dart';

abstract final class AppRadii {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 18;
  static const double pill = 999;

  static const BorderRadius xsBr = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smBr = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdBr = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgBr = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius pillBr = BorderRadius.all(Radius.circular(pill));
}
