import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lints/src/alpha_ordering/sorters.dart';

class PreferEnumConstantsSortedAlphabetically extends AnalysisRule {
  PreferEnumConstantsSortedAlphabetically()
    : super(
        name: 'prefer_enum_constants_sorted_alphabetically',
        description: 'Enum constants must be sorted alphabetically.',
      );

  static const code = LintCode(
    'prefer_enum_constants_sorted_alphabetically',
    'Enum constant "{0}" is out of alphabetical order.',
    correctionMessage: 'Sort enum constants alphabetically.',
    severity: DiagnosticSeverity.INFO,
  );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this);
    registry.addEnumDeclaration(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  _Visitor(this.rule);

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    final enumConstants = node.body.constants;
    const EnumConstantDeclarationSorter().reportUnsorted(rule, enumConstants);
  }
}
