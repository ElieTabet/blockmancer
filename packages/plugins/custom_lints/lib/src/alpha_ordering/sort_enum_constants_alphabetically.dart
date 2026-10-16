import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:custom_lints/src/alpha_ordering/extensions.dart';
import 'package:custom_lints/src/alpha_ordering/sorters.dart';

class SortEnumConstantsAlphabetically extends ResolvedCorrectionProducer {
  SortEnumConstantsAlphabetically({required super.context});

  static const _kind = FixKind(
    'custom_lints.fix.sort_enum_constants_alphabetically',
    DartFixKindPriority.standard,
    'Sort enum constants alphabetically',
  );

  static const _kindMulti = FixKind(
    'custom_lints.fix.sort_enum_constants_alphabetically.multi',
    DartFixKindPriority.inFile,
    'Sort enum constants alphabetically in File',
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
    if (node is! EnumConstantDeclaration) return;

    final enumConstants = node
        .getParentOfType<EnumDeclaration>()
        ?.body
        .constants;
    if (enumConstants == null) return;

    return const EnumConstantDeclarationSorter().rearrange(
      enumConstants,
      builder,
      file,
    );
  }
}
