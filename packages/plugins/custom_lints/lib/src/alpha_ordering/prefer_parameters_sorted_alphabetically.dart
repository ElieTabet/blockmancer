import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lints/src/alpha_ordering/sorters.dart';

const _desc =
    'Parameters must be sorted alphabetically (required params first, then optional params, each group sorted alphabetically).';

class PreferParametersSortedAlphabetically extends AnalysisRule {
  PreferParametersSortedAlphabetically()
    : super(
        name: 'prefer_parameters_sorted_alphabetically',
        description: _desc,
      );

  static const code = LintCode(
    'prefer_parameters_sorted_alphabetically',
    'Parameter "{0}" is out of alphabetical order within its group (required before optional, each group sorted).',
    correctionMessage:
        'Sort required parameters alphabetically first, then optional parameters alphabetically.',
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
    registry
      ..addConstructorDeclaration(this, visitor)
      ..addFunctionDeclaration(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  _Visitor(this.rule);

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    const FormalParameterSorter().reportUnsorted(
      rule,
      node.parameters.parameters,
    );
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    const FormalParameterSorter().reportUnsorted(
      rule,
      node.functionExpression.parameters?.parameters,
    );
  }
}
