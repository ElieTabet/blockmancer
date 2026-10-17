import 'package:flutter/painting.dart';

/// Where the map puts each world: a row each, the first at the top, swinging
/// from side to side so the trail between them winds. The nodes and the trail
/// both place themselves from here, so they meet.
abstract final class MapGeometry {
  /// Each row's badge centre, as a share of the map's width.
  static const _swing = [0.5, 0.76, 0.5, 0.24];
  static const badgeSize = 64.0;

  /// The room above a badge for "you are here".
  static const markerHeight = 30.0;
  static const nodeWidth = 124.0;
  static const rowHeight = 150.0;

  static Offset badgeCenterOf(int index, {required double width}) => Offset(
    width * _swing[index % _swing.length],
    rowHeight * index + markerHeight + badgeSize / 2,
  );

  static double heightOf(int count) => rowHeight * count;
}
