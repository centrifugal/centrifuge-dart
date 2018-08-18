import 'dart:convert';

import "package:test/test.dart";
import 'package:centrifuge/centrifuge.dart';
import 'dart:io';

void main() {
  Centrifuge centrifuge;
  setUp(() {
    centrifuge = Centrifuge(url: 'ws://localhost:8000/connection');
  });

  test("Centrifuge.disconnect() works without connection", () async {
    await centrifuge.disconnect();
  });
}
