#!/bin/bash

screen -S buddybuild-script -d -m $(while true; do date >> all-the-dates.txt; sleep 1; done)
