import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:custom_lints/src/alpha_ordering/extensions.dart';
import 'package:custom_lints/src/alpha_ordering/sorters.dart';

class SortFieldDeclarationsAlphabetically extends ResolvedCorrectionProducer {
  SortFieldDeclarationsAlphabetically({required super.context});

  static const _kind = FixKind(
    'custom_lints.fix.sort_field_declarations_alphabetically',
    DartFixKindPriority.standard,
    'Sort field declarations alphabetically',
  );

  static const _kindMulti = FixKind(
    'custom_lints.fix.sort_field_declarations_alphabetically.multi',
    DartFixKindPriority.inFile,
    'Sort field declarations alphabetically in File',
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossSingleFile;

  @override
  FixKind get fixKind => _kind;

  @override
  FixKind get multiFixKind => _kindMulti;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = coveringNode;
    if (node is! FieldDeclaration) return;

    final classBody = node.getParentOfType<ClassDeclaration>()?.body;
    if (classBody is! BlockClassBody) return;

    final fieldDeclarations = classBody.members
        .whereType<FieldDeclaration>()
        .toList();

    return const FieldDeclarationSorter().rearrange(
      fieldDeclarations,
      builder,
      file,
    );
  }
}
