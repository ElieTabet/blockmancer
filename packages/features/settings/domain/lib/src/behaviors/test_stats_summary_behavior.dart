import 'dart:convert';

import 'package:settings_domain/src/entities/app_details.br.dart';
import 'package:settings_domain/src/providers_di.br.dart';

/// In English whatever the app shows: the team reads it.
const testStatsSubject = 'Blockmancer test stats';

/// The summary a tester sends: the play stats, and the build they came from,
/// so a summary says which version was played. Nothing in it says who played:
/// the device is named by a random install id alone, and its model and OS are
/// left out.
class TestStatsSummaryBehavior {
  final Future<AppDetails> _appDetails;
  final ExportTestStatsFun _exportTestStats;

  const TestStatsSummaryBehavior({
    required Future<AppDetails> appDetails,
    required ExportTestStatsFun exportTestStats,
  }) : _appDetails = appDetails,
       _exportTestStats = exportTestStats;

  Future<String> call() async {
    final (details, stats) = await (_appDetails, _exportTestStats()).wait;

    return const JsonEncoder.withIndent('  ').convert({
      'app': {'build': details.build, 'version': details.version},
      ...jsonDecode(stats) as Map<String, dynamic>,
    });
  }
}
