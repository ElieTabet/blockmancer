import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_presentation/src/widgets/continue_card.dart';
import 'package:home_presentation/src/widgets/daily_card.dart';
import 'package:home_presentation/src/widgets/home_header.dart';
import 'package:home_presentation/src/widgets/unlock_announcer.dart';
import 'package:home_presentation/src/widgets/update_banner.dart';
import 'package:home_presentation/src/widgets/world_map.dart';

/// The first tab: today's daily run on top, then the world map.
final class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) => const AnnotatedRegion(
    value: SystemUiOverlayStyle.light,
    child: Scaffold(
      backgroundColor: DSColor.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: .fromLTRB(
            DSSpace.large,
            DSSpace.xsmall,
            DSSpace.large,
            DSSpace.xxlarge,
          ),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              HomeHeader(),
              SizedBox(height: DSSpace.medium),
              UpdateBanner(),
              DailyCard(),
              SizedBox(height: DSSpace.small),
              ContinueCard(),
              SizedBox(height: DSSpace.small),
              WorldMapHeading(),
              WorldMap(),
              UnlockAnnouncer(),
            ],
          ),
        ),
      ),
    ),
  );
}
