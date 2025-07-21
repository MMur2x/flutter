// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter_driver/flutter_driver.dart' as flutter_driver;
import 'package:flutter_driver/flutter_driver.dart' show Timeline, TimelineSummary;
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:flutter_test/flutter_test.dart' hide TypeMatcher, isInstanceOf;

void main() {
  group('scrolling performance test', () {
    late flutter_driver.FlutterDriver driver;

    setUpAll(() async {
      driver = await flutter_driver.FlutterDriver.connect();
    });

    tearDownAll(() async {
      driver.close();
    });

    test('measure', () async {
      final Timeline timeline = await driver.traceAction(() async {
        // Find the scrollable stock list
        final flutter_driver.SerializableFinder stockList = flutter_driver.find.byValueKey('stock-list');
        flutter_test.expect(stockList, flutter_test.isNotNull);

        // Scroll down
        for (int i = 0; i < 5; i++) {
          await driver.scroll(stockList, 0.0, -300.0, const Duration(milliseconds: 300));
          await Future<void>.delayed(const Duration(milliseconds: 500));
        }

        // Scroll up
        for (int i = 0; i < 5; i++) {
          await driver.scroll(stockList, 0.0, 300.0, const Duration(milliseconds: 300));
          await Future<void>.delayed(const Duration(milliseconds: 500));
        }
      });

      final TimelineSummary summary = TimelineSummary.summarize(timeline);
      await summary.writeTimelineToFile('stocks_scroll_perf', pretty: true);
    }, timeout: Timeout.none);
  });
}
