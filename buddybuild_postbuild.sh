#!/usr/bin/env bash

# Install gems locally
bundle install --path Vendor --quiet

# Hack while we get our PR merged in Danger's repo
find Vendor/ruby -type d -name ci_source -exec cp Vendor/danger_buddybuild.rb {} \;

bundle exec danger --fail-on-errors=true
