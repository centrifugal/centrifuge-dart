#!/bin/bash

# Copyright (c) 2015, the Dart project authors. Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

# Fast fail the script on failures.
set -e

# Run pub get to fetch packages.
pub global activate coverage
pub get

# Verify that the libraries are error and warning-free.
echo "Running dartanalyzer..."
dartanalyzer $DARTANALYZER_FLAGS \
  lib/

# Verify that dartfmt has been run.
echo "Checking dartfmt..."
if [[ $(dartfmt -n --set-exit-if-changed lib/ test/) ]]; then
	echo "Failed dartfmt check: run dartfmt -w lib/ test/"
	exit 1
fi

# Run the tests.
echo "Running tests..."
pub run test --reporter expanded

# Gather coverage and upload to Coveralls.
if [ "$COVERALLS_TOKEN" ] && [ "$TRAVIS_DART_VERSION" = "dev" ]; then
  OBS_PORT=9292
  echo "Collecting coverage on port $OBS_PORT..."

  # Start tests in one VM.
  dart --disable-service-auth-codes \
    --enable-vm-service=$OBS_PORT \
    --pause-isolates-on-exit \
    test/test_all.dart &

  # Run the coverage collector to generate the JSON coverage report.
  pub global run coverage:collect_coverage \
    --port=$OBS_PORT \
    --out=var/coverage.json \
    --wait-paused \
    --resume-isolates

  echo "Generating LCOV report..."
  pub global run coverage:format_coverage \
    --lcov \
    --in=var/coverage.json \
    --out=var/lcov.info \
    --packages=.packages \
    --report-on=lib
fi