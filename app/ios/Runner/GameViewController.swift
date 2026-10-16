import Flutter
import UIKit

// Pieces are dragged up from a tray near the bottom edge, which iOS reads as
// the swipe home. Deferring that edge lets the drag through: going home takes
// a second swipe. Flutter's own view controller doesn't expose the setting.
class GameViewController: FlutterViewController {
  override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
    .bottom
  }
}
