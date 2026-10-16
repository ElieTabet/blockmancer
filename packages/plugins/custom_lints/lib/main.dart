import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:custom_lints/src/alpha_ordering/prefer_enum_constants_sorted_alphabetically.dart';
import 'package:custom_lints/src/alpha_ordering/prefer_field_declarations_sorted_alphabetically.dart';
import 'package:custom_lints/src/alpha_ordering/prefer_parameters_sorted_alphabetically.dart';
import 'package:custom_lints/src/alpha_ordering/sort_enum_constants_alphabetically.dart';
import 'package:custom_lints/src/alpha_ordering/sort_field_declarations_alphabetically.dart';
import 'package:custom_lints/src/alpha_ordering/sort_parameters_alphabetically.dart';

final plugin = CustomLintsPlugin();

class CustomLintsPlugin extends Plugin {
  @override
  void register(PluginRegistry registry) {
    registry
      ..registerLintRule(PreferParametersSortedAlphabetically())
      ..registerFixForRule(
        PreferParametersSortedAlphabetically.code,
        SortParametersAlphabetically.new,
      )
      ..registerLintRule(PreferFieldDeclarationsSortedAlphabetically())
      ..registerFixForRule(
        PreferFieldDeclarationsSortedAlphabetically.code,
        SortFieldDeclarationsAlphabetically.new,
      )
      ..registerLintRule(PreferEnumConstantsSortedAlphabetically())
      ..registerFixForRule(
        PreferEnumConstantsSortedAlphabetically.code,
        SortEnumConstantsAlphabetically.new,
      );
  }

  @override
  String get name => 'custom_lints';
}
