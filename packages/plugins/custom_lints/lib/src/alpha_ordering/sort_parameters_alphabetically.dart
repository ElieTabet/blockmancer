import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:custom_lints/src/alpha_ordering/extensions.dart';
import 'package:custom_lints/src/alpha_ordering/sorters.dart';

class SortParametersAlphabetically extends ResolvedCorrectionProducer {
  SortParametersAlphabetically({required super.context});

  static const _kind = FixKind(
    'custom_lints.fix.sort_parameters_alphabetically',
    DartFixKindPriority.standard,
    'Sort parameters alphabetically',
  );

  static const _kindMulti = FixKind(
    'custom_lints.fix.sort_parameters_alphabetically.multi',
    DartFixKindPriority.inFile,
    'Sort parameters alphabetically in File',
  );

  @override
  FixKind get fixKind => _kind;

  @override
  FixKind get multiFixKind => _kindMulti;

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.acrossSingleFile;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = coveringNode;
    if (node is! FormalParameter) return;

    final parameters = node.getParentOfType<FormalParameterList>()?.parameters;
    if (parameters == null) return;

    return const FormalParameterSorter().rearrange(parameters, builder, file);
  }
}
