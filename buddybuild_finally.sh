#!/usr/bin/env bash

screen -ls
cat all-the-dates.txt

# Install gems locally
bundle install --quiet

bundle exec danger --fail-on-errors=true --verbose
