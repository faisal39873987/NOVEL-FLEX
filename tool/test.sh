#!/usr/bin/env sh
set -eu

# Flutter 3.44 can crash on macOS resource-fork files generated under
# build/native_assets on this external volume. The tests below do not need an
# asset bundle, so keep the run deterministic and fast.
rm -rf build/native_assets
flutter test --no-test-assets "$@"
