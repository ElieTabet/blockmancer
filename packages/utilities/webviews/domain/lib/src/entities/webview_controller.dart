import 'package:webviews_domain/src/entities/webview_command.dart';

typedef JavascriptEvaluator = Future<String?> Function(String source);

class WebviewController {
  JavascriptEvaluator? _evaluator;

  bool get isAttached => _evaluator != null;

  // ignore: use_setters_to_change_properties
  void attach(JavascriptEvaluator evaluator) => _evaluator = evaluator;

  void detach() => _evaluator = null;

  Future<String?> execute(WebviewCommand command) {
    final evaluator = _evaluator;

    if (evaluator == null) {
      throw StateError('WebviewController is not attached to a Webview');
    }

    return evaluator(command.toJavascript());
  }
}
