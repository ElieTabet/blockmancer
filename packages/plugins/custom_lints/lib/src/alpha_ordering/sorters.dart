import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';

sealed class Sorter<T extends AstNode> {
  const Sorter({required this.nameExtractor, this.comparePriority});

  final int Function(T a, T b)? comparePriority;
  final String? Function(T item) nameExtractor;

  int compare(T a, T b) {
    final priority = comparePriority?.call(a, b) ?? 0;
    if (priority != 0) return priority;
    return _compareNames(a, b);
  }

  int _compareNames(T a, T b) {
    final aName = nameExtractor(a);
    final bName = nameExtractor(b);
    if (aName == bName) return 0;
    if (aName == null) return -1;
    if (bName == null) return 1;
    return aName.compareTo(bName);
  }

  List<T> sortAlphabetically(List<T> items) {
    final sorted = List<T>.from(items)..sort(compare);
    return sorted;
  }

  void reportUnsorted(AnalysisRule rule, List<T>? items) {
    if (items == null) return;
    final firstUnsortedItem = _firstUnsorted(items);
    if (firstUnsortedItem != null) {
      rule.reportAtNode(
        firstUnsortedItem,
        arguments: [nameExtractor(firstUnsortedItem) ?? ''],
      );
    }
  }

  Future<void> rearrange(
    List<T> unsortedItems,
    ChangeBuilder builder,
    String file,
  ) {
    final sortedItems = sortAlphabetically(unsortedItems);
    return builder.addDartFileEdit(file, (builder) {
      for (int i = 0; i < unsortedItems.length; i++) {
        final original = unsortedItems[i];
        final sorted = sortedItems[i];

        if (original != sorted) {
          builder.addReplacement(
            SourceRange(original.offset, original.length),
            (builder) => builder.write(sorted.toSource()),
          );
        }
      }
    });
  }

  T? _firstUnsorted(List<T> items) {
    final length = items.length;
    if (length < 2) {
      return null;
    }
    for (int i = 1; i < length; i++) {
      if (compare(items[i - 1], items[i]) > 0) {
        return items[i];
      }
    }
    return null;
  }
}

final class FormalParameterSorter extends Sorter<FormalParameter> {
  const FormalParameterSorter()
    : super(nameExtractor: _nameOf, comparePriority: _comparePriority);

  static int _comparePriority(FormalParameter a, FormalParameter b) =>
      a.priority.compareTo(b.priority);
  static String? _nameOf(FormalParameter param) => param.name?.lexeme;
}

final class FieldDeclarationSorter extends Sorter<FieldDeclaration> {
  const FieldDeclarationSorter() : super(nameExtractor: _nameOf);

  static String? _nameOf(FieldDeclaration field) =>
      field.fields.variables.first.name.lexeme;
}

final class EnumConstantDeclarationSorter
    extends Sorter<EnumConstantDeclaration> {
  const EnumConstantDeclarationSorter() : super(nameExtractor: _nameOf);

  static String? _nameOf(EnumConstantDeclaration constant) =>
      constant.name.lexeme;
}

extension on FormalParameter {
  int get priority {
    int result = 0;
    if (isNamed) result += 1000;
    if (isOptional) result += 100;
    if (isSuper) result += 10;
    if (!isRef) result += 1;

    return result;
  }

  bool get isSuper {
    final self = this;
    if (self is DefaultFormalParameter) {
      return self.parameter is SuperFormalParameter;
    }
    return self is SuperFormalParameter;
  }

  bool get isRef {
    final self = this;
    if (self is SimpleFormalParameter) {
      return self.type?.toSource() == 'Ref';
    }
    return false;
  }
}
