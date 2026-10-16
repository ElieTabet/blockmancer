import 'package:analyzer/dart/ast/ast.dart';

extension AstNodeExtension on AstNode {
  T? getParentOfType<T extends AstNode>() {
    AstNode? current = this;
    while (current != null) {
      if (current is T) return current;
      current = current.parent;
    }
    return null;
  }
}
