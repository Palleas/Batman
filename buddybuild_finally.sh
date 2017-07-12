#!/usr/bin/env bash

printenv 

# Install gems locally
bundle install --quiet

bundle exec danger --fail-on-errors=true --verbose
