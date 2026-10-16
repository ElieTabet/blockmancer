import 'package:flutter/material.dart';

final class DSLinearGradientContainer extends Container {
  // Constructors
  DSLinearGradientContainer({
    super.key,
    required List<Color> colors,
    required Alignment startAlignment,
    required Alignment endAlignment,
    required Widget child,
  }) : super(
         decoration: BoxDecoration(
           gradient: LinearGradient(
             colors: colors,
             begin: startAlignment,
             end: endAlignment,
           ),
         ),
         child: child,
       );
}
