#!/usr/bin/env bash

# Combined code coverage and test runner for Ditonton modular architecture
error=false

show_help() {
  printf "usage: $0 [--help]\nTool for running all unit and widget tests with code coverage across modular packages.\n"
  exit 1
}

runTests() {
  pkg=$1
  root_dir=$2
  if [ -d "$pkg" ] && [ -f "$pkg/pubspec.yaml" ] && [ -d "$pkg/test" ]; then
    echo "=========================================="
    echo "Running tests in $pkg"
    echo "=========================================="
    cd "$pkg" || exit
    flutter pub get
    flutter test --coverage || error=true

    if [ -f "coverage/lcov.info" ]; then
      mkdir -p "$root_dir/coverage"
      escaped_path=$(echo "$pkg" | sed 's/\//\\\//g')
      sed "s/^SF:lib/SF:$escaped_path\/lib/g" coverage/lcov.info >> "$root_dir/coverage/lcov.info"
    fi
    cd "$root_dir" || exit
  fi
}

ROOT_DIR=$(pwd)

if [ -d "coverage" ]; then
  rm -rf coverage
fi

PACKAGES=(
  "packages/core"
  "packages/about"
  "packages/movie"
  "packages/tv"
  "packages/search"
  "packages/watchlist"
  "."
)

for pkg in "${PACKAGES[@]}"; do
  runTests "$pkg" "$ROOT_DIR"
done

if [ -f "coverage/lcov.info" ] && command -v genhtml &> /dev/null; then
  echo "Generating HTML coverage report..."
  genhtml coverage/lcov.info -o coverage/html
fi

if [ "$error" = true ]; then
  echo "Some tests failed!"
  exit 1
else
  echo "All modular tests passed successfully!"
  exit 0
fi
