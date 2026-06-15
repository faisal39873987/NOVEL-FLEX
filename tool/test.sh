#!/usr/bin/env sh
set -eu

# Flutter 3.44 can crash on macOS resource-fork files generated under
# build/native_assets on this external volume. The tests below do not need an
# asset bundle, so keep the run deterministic and fast.
rm -rf build/native_assets

current_apiutils_imports="$(mktemp)"
rg -l "import .*ApiUtils\\.dart|import ['\"].*Utils/ApiUtils\\.dart" lib --glob '*.dart' | sort > "$current_apiutils_imports"
if ! diff -u tool/legacy_apiutils_allowlist.txt "$current_apiutils_imports"; then
  rm -f "$current_apiutils_imports"
  echo "New ApiUtils import detected. Use Supabase services/repositories for new MVP work." >&2
  exit 1
fi
rm -f "$current_apiutils_imports"

flutter test --no-test-assets "$@"
