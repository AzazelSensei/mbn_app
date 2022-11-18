import 'package:flutter/material.dart';

extension UIEx on BuildContext {
  Size get toSize => MediaQuery.of(this).size;
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get lowHeight => toSize.height * 0.025;
  double get normalHeight => toSize.height * 0.05;
  double get largeHeight => toSize.height * 0.07;

  double get lowWidth => toSize.width * 0.0025;
  double get normalWidth => toSize.width * 0.5;
  double get largeWidth => toSize.width * 0.7;
}
