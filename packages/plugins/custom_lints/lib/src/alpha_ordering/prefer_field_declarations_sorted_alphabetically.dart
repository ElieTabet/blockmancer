import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:custom_lints/src/alpha_ordering/sorters.dart';

class PreferFieldDeclarationsSortedAlphabetically extends AnalysisRule {
  PreferFieldDeclarationsSortedAlphabetically()
    : super(
        name: 'prefer_field_declarations_sorted_alphabetically',
        description: 'Field declarations must be sorted alphabetically.',
      );

  static const code = LintCode(
    'prefer_field_declarations_sorted_alphabetically',
    'Field declaration "{0}" is out of alphabetical order.',
    correctionMessage: 'Sort field declarations alphabetically.',
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
    registry.addClassDeclaration(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  _Visitor(this.rule);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final body = node.body;
    if (body is! BlockClassBody) return;

    final fieldDeclarations = body.members
        .whereType<FieldDeclaration>()
        .toList();
    const FieldDeclarationSorter().reportUnsorted(rule, fieldDeclarations);
  }
}
