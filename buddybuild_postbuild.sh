#!/usr/bin/env bash

mkdir -p buddybuild_artifacts/swiftlint
swiftlint > buddybuild_artifacts/swiftlint/report.xml
