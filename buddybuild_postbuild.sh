#!/usr/bin/env bash

mkdir -p buddybuild_artifacts/swiftlint

swiftlint --config "$BUDDYBUILD_WORKSPACE/.swiftlint.yml" > buddybuild_artifacts/swiftlint/swiftlint.xml

cat buddybuild_artifacts/swiftlint/swiftlint.xml
