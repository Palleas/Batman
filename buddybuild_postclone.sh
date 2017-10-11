#!/bin/bash

screen -S buddybuild-script -d -m bash -c "while true; do date >> all-the-dates.txt; sleep 1; done"
