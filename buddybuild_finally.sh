#!/usr/bin/env bash

chruby 2.3.1

# Install gems locally
bundle install --quiet

bundle exec danger --fail-on-errors=true --verbose
