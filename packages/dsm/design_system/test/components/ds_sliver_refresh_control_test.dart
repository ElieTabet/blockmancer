import 'package:design_system/design_system.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester, {
  required Future<void> Function() onRefresh,
  double contentHeight = 2000,
}) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: DSTheme.instance.lightTheme,
      home: Scaffold(
        body: CustomScrollView(
          physics: DSSliverRefreshControl.physics,
          slivers: [
            DSSliverRefreshControl(onRefresh: onRefresh),
            SliverToBoxAdapter(child: SizedBox(height: contentHeight)),
          ],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Given a page that can be refreshed '
      'When the reader pulls down on it '
      'Then the refresh runs', (tester) async {
    var refreshes = 0;

    await _pump(
      tester,
      onRefresh: () async {
        refreshes++;
      },
    );

    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, 300),
      800,
    );
    await tester.pumpAndSettle();

    expect(refreshes, 1);
  });

  // Short content is the empty and failed states of every screen that uses
  // this — the gesture has to work there too, which is what the always-
  // scrollable half of [DSSliverRefreshControl.physics] buys.
  testWidgets('Given a page too short to scroll '
      'When the reader pulls down on it '
      'Then the refresh still runs', (tester) async {
    var refreshes = 0;

    await _pump(
      tester,
      contentHeight: 10,
      onRefresh: () async {
        refreshes++;
      },
    );

    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, 300),
      800,
    );
    await tester.pumpAndSettle();

    expect(refreshes, 1);
  });

  // One app, one spinner: the same circular indicator the rest of the app
  // loads with, not the tick-spinner Cupertino draws by default.
  testWidgets('Given a refresh in flight '
      'When the reader looks at the page '
      'Then it is the app\'s own circular indicator turning', (tester) async {
    await _pump(tester, onRefresh: () => Future<void>.delayed(Duration.zero));

    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, 300),
      800,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(CupertinoActivityIndicator), findsNothing);

    await tester.pumpAndSettle();
  });

  group('Which end gives', () {
    final metrics = FixedScrollMetrics(
      minScrollExtent: 0,
      maxScrollExtent: 1000,
      pixels: 1000,
      viewportDimension: 800,
      axisDirection: AxisDirection.down,
      devicePixelRatio: 3,
    );

    // The pull that opens the refresh control. Zero means "no correction" —
    // the scroll position is allowed to go where it was asked.
    test('the top gives, because that is where a refresh is asked for', () {
      // Given a page scrolled to the very top
      final atTop = FixedScrollMetrics(
        minScrollExtent: 0,
        maxScrollExtent: 1000,
        pixels: 0,
        viewportDimension: 800,
        axisDirection: AxisDirection.down,
        devicePixelRatio: 3,
      );

      // When the reader drags further down than there is content
      final correction = DSSliverRefreshControl.physics.applyBoundaryConditions(
        atTop,
        -80,
      );

      // Then nothing is taken back: the overscroll stands
      expect(correction, 0);
    });

    test('the bottom does not, because a pull there refreshes nothing', () {
      // Given a page scrolled to the very bottom
      // When the reader drags past the end
      final correction = DSSliverRefreshControl.physics.applyBoundaryConditions(
        metrics,
        1080,
      );

      // Then every pixel of it is taken back
      expect(correction, 80);
    });

    test('scrolling up to the bottom edge is still allowed', () {
      // Given a page part-way down
      final partWay = FixedScrollMetrics(
        minScrollExtent: 0,
        maxScrollExtent: 1000,
        pixels: 950,
        viewportDimension: 800,
        axisDirection: AxisDirection.down,
        devicePixelRatio: 3,
      );

      // When a frame would carry it past the end
      final correction = DSSliverRefreshControl.physics.applyBoundaryConditions(
        partWay,
        1020,
      );

      // Then it travels as far as the edge and no further
      expect(correction, 20);
    });
  });
}
