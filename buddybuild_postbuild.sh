#!/usr/bin/env bash

TARGET="$BUDDYBUILD_WORKSPACE/buddybuild_artifacts/swiftlint"
mkdir -p "$TARGET"

swiftlint --config "$BUDDYBUILD_WORKSPACE/.swiftlint.yml" > "$TARGET/swiftlint.xml"
