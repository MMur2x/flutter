// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart' as fd;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('basic stock view test', () {
    late fd.FlutterDriver driver;

    setUpAll(() async {
      driver = await fd.FlutterDriver.connect();
    });

    tearDownAll(() async {
      driver.close();
    });

    test('Stock list is shown', () async {
      final fd.SerializableFinder stockList = fd.find.byValueKey('stock-list');
      expect(stockList, isNotNull);
    }, timeout: Timeout.none);

    test(
      'open AAPL stock',
      () async {
        final fd.SerializableFinder stockList = fd.find.byValueKey('stock-list');
        expect(stockList, isNotNull);

        final fd.SerializableFinder aaplStockRow = fd.find.byValueKey('AAPL');
        await driver.scrollUntilVisible(stockList, aaplStockRow);

        await driver.tap(aaplStockRow);
        await Future<void>.delayed(const Duration(milliseconds: 500));

        final fd.SerializableFinder stockOption = fd.find.byValueKey('AAPL_symbol_name');
        final String symbol = await driver.getText(stockOption);

        expect(symbol, 'AAPL');
      },
      skip: 'Needs to be fixed on Fuchsia.', // https://github.com/flutter/flutter/issues/87069
      timeout: Timeout.none,
    );
  });
}
